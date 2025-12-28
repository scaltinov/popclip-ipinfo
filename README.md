# IP Info - PopClip Extension

A PopClip extension that displays detailed information about IP addresses (both IPv4 and IPv6).

IP情報を表示するPopClip拡張機能（IPv4/IPv6対応）

## Features

- **IPv4 and IPv6 Support**: Works with both IPv4 and IPv6 addresses
- **PTR Records**: Display reverse DNS lookup results
- **Organization Information**: Show the organization that owns the IP
- **Country**: Display the country associated with the IP address
- **ASN (Autonomous System Number)**: Show ASN information
- **Abuse Contact**: Display abuse contact information
- **Network Range/CIDR**: Optional display of IP range and CIDR notation
- **Description**: Optional detailed description and network name

## Installation

1. Download or clone this repository
2. Double-click the `IPInfo.popclipext` folder (or the packaged extension)
3. PopClip will prompt you to install the extension

Or install directly by copying to PopClip's extensions directory:
```bash
cp -r IPInfo.popclipext ~/Library/Application\ Support/PopClip/Extensions/
```

## Usage

1. Select any IPv4 or IPv6 address in any application
2. Click the IP Info button in the PopClip menu
3. View the IP information in a dialog or have it copied to your clipboard

## Configuration Options

The extension provides several customizable options:

- **PTRレコードを表示** (Show PTR Record): Display reverse DNS lookup - Default: ON
- **組織名を表示** (Show Organization): Display organization name - Default: ON
- **国を表示** (Show Country): Display country information - Default: ON
- **ASN（自律システム番号）を表示** (Show ASN): Display Autonomous System Number - Default: ON
- **Abuse連絡先を表示** (Show Abuse Contact): Display abuse contact information - Default: ON
- **説明/ネットワーク名の詳細を表示** (Show Description): Display detailed description - Default: OFF
- **IPレンジ/CIDRを表示** (Show Network Range/CIDR): Display IP range information - Default: OFF
- **クリップボードにコピー** (Copy to Clipboard): Automatically copy results to clipboard - Default: ON
- **ダイアログで確認** (Show Dialog): Display results in a dialog - Default: ON

Access these settings by clicking the gear icon next to the extension in PopClip's preferences.

## Requirements

- macOS
- PopClip
- Internet connection for IP lookups
- `whois` and `dig` command-line tools (pre-installed on macOS)

## Icon

Uses `eos-icons:ip` from [Iconify](https://iconify.design/)

## License

MIT

## Author

Created with [Claude Code](https://claude.com/claude-code)
