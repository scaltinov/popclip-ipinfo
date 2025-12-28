#!/bin/bash
# PopClip Extension: IP Info
# Get PTR (reverse DNS) and whois information for selected IP address
# With user-configurable options

IP="${1:-$POPCLIP_TEXT}"

# Get option values from PopClip (default to "1" if not set)
COPY_CLIPBOARD="${POPCLIP_OPTION_COPY_TO_CLIPBOARD:-1}"
SHOW_PTR="${POPCLIP_OPTION_SHOW_PTR:-1}"
SHOW_ORG="${POPCLIP_OPTION_SHOW_ORG:-1}"
SHOW_COUNTRY="${POPCLIP_OPTION_SHOW_COUNTRY:-1}"
SHOW_DIALOG="${POPCLIP_OPTION_SHOW_DIALOG:-1}"
SHOW_ASN="${POPCLIP_OPTION_SHOW_ASN:-1}"
SHOW_ABUSE="${POPCLIP_OPTION_SHOW_ABUSE:-1}"
SHOW_DESCR="${POPCLIP_OPTION_SHOW_DESCR:-0}"
SHOW_NETRANGE="${POPCLIP_OPTION_SHOW_NETRANGE:-0}"

# Validate IP address
is_ipv4() {
  local ip=$1
  if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    local IFS='.'
    local -a octets=($ip)
    for octet in "${octets[@]}"; do
      ((octet > 255)) && return 1
    done
    return 0
  fi
  return 1
}

is_ipv6() {
  local ip=$1
  # Basic IPv6 validation (hex digits and colons, contains at least one colon)
  [[ $ip =~ ^[0-9a-fA-F:]+$ ]] && [[ $ip =~ : ]] && [[ ! $ip =~ :::+ ]]
}

if ! is_ipv4 "$IP" && ! is_ipv6 "$IP"; then
  osascript -e 'display notification "Invalid IP address" with title "IP Info"'
  exit 0
fi

# Initialize output with IP address
OUTPUT="IP: $IP"

# Shared variable for whois data (lazy loading)
WHOIS_DATA=""

# PTR lookup (if enabled)
if [ "$SHOW_PTR" = "1" ]; then
  PTR=$(dig -x "$IP" +short +time=2 2>/dev/null | sed 's/\.$//' | head -n 1)
  if [ -n "$PTR" ]; then
    OUTPUT+="\nPTR: $PTR"
  else
    OUTPUT+="\nPTR: (not found)"
  fi
fi

# Organization name (if enabled)
if [ "$SHOW_ORG" = "1" ]; then
  [ -z "$WHOIS_DATA" ] && WHOIS_DATA=$(whois "$IP" 2>/dev/null)
  ORG=$(echo "$WHOIS_DATA" | egrep -i '^(orgname|org-name|organization|netname):' | head -n1 | sed 's/^[^:]*:[ \t]*//')
  [ -n "$ORG" ] && OUTPUT+="\nOrg: $ORG"
fi

# Country (if enabled)
if [ "$SHOW_COUNTRY" = "1" ]; then
  [ -z "$WHOIS_DATA" ] && WHOIS_DATA=$(whois "$IP" 2>/dev/null)
  COUNTRY=$(echo "$WHOIS_DATA" | egrep -i '^country:' | head -n1 | sed 's/^[^:]*:[ \t]*//')
  [ -n "$COUNTRY" ] && OUTPUT+="\nCountry: $COUNTRY"
fi

# ASN (if enabled)
if [ "$SHOW_ASN" = "1" ]; then
  [ -z "$WHOIS_DATA" ] && WHOIS_DATA=$(whois "$IP" 2>/dev/null)
  ASN=$(echo "$WHOIS_DATA" | egrep -i '^(originas|origin):' | head -n1 | sed 's/^[^:]*:[ \t]*//')
  [ -n "$ASN" ] && OUTPUT+="\nASN: $ASN"
fi

# Abuse contact (if enabled)
if [ "$SHOW_ABUSE" = "1" ]; then
  [ -z "$WHOIS_DATA" ] && WHOIS_DATA=$(whois "$IP" 2>/dev/null)
  ABUSE=$(echo "$WHOIS_DATA" | egrep -i '^(abuse-mailbox|orgabuseemail|abuse):' | head -n1 | sed 's/^[^:]*:[ \t]*//')
  [ -n "$ABUSE" ] && OUTPUT+="\nAbuse: $ABUSE"
fi

# Description (if enabled)
if [ "$SHOW_DESCR" = "1" ]; then
  [ -z "$WHOIS_DATA" ] && WHOIS_DATA=$(whois "$IP" 2>/dev/null)
  DESCR=$(echo "$WHOIS_DATA" | egrep -i '^(descr|description):' | head -n1 | sed 's/^[^:]*:[ \t]*//')
  [ -n "$DESCR" ] && OUTPUT+="\nDescr: $DESCR"
fi

# NetRange/CIDR (if enabled)
if [ "$SHOW_NETRANGE" = "1" ]; then
  [ -z "$WHOIS_DATA" ] && WHOIS_DATA=$(whois "$IP" 2>/dev/null)
  NETRANGE=$(echo "$WHOIS_DATA" | egrep -i '^(netrange|inetnum|cidr):' | head -n1 | sed 's/^[^:]*:[ \t]*//')
  [ -n "$NETRANGE" ] && OUTPUT+="\nNetRange: $NETRANGE"
fi

# Copy results to clipboard if enabled
if [ "$COPY_CLIPBOARD" = "1" ] && [ -n "$OUTPUT" ]; then
  printf "%s" "$OUTPUT" | pbcopy
fi

# Display results either via dialog or PopClip's standard output
if [ -n "$OUTPUT" ]; then
  if [ "$SHOW_DIALOG" = "1" ]; then
    osascript <<'OSA' "$OUTPUT"
on run argv
  display dialog item 1 of argv buttons {"OK"} default button "OK" with title "IP Info"
end run
OSA
  else
    echo -e "$OUTPUT"
  fi
fi
