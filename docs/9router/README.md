# 9router

## Using VPN

### Option 1: Inject into terminal

Turning on `Set system proxy` in V2ray. Then inject the proxy port into the terminal session's environment variables:

```bash
export http_proxy=http://127.0.0.1:10809
export https_proxy=http://127.0.0.1:10809
export ALL_PROXY=socks5://127.0.0.1:10808

```

Finally, start `9router` in the terminal.

### Option 2: TUN Mode

Turn TUN Mode on within your VPN client or system settings to route all network traffic through the virtual network interface automatically. Once enabled, simply launch `9router` without needing to configure terminal-specific environment variables.

---

## Proxy Pool

To utilize multiple proxies, distribute traffic, and avoid rate limits, you can configure `9router` to use a Proxy Pool.

1. **Define your pool:** Create a text file (e.g., `proxies.txt`) containing your proxy list, with one proxy per line.

```text
http://username:password@192.168.1.100:8080
socks5://192.168.1.101:1080

```

1. **Launch with the pool flag:** Start the application and point it to your proxy list.

```bash
9router --pool proxies.txt --rotate-interval 60s

```

`9router` will automatically load-balance and rotate through the available proxies based on your configured interval or per-request rules.

---

## Combo

The Combo mode allows you to combine the system-wide coverage of **TUN Mode** with the flexibility of a **Proxy Pool** for granular routing and advanced anonymity. This is ideal for routing standard system traffic through a primary VPN, while pushing specific scraping or high-volume tasks through rotating proxies.

Enable Combo mode by initializing `9router` with both configurations:

```bash
9router --tun --pool proxies.txt --mode combo

```

**Key Notes for Combo Mode:**

* **Routing Priority:** By default, targeted application requests use the Proxy Pool. All fallback or unassigned system traffic routes through the TUN interface.
* **Conflict Check:** Ensure your VPN (TUN) and Proxy Pool do not share conflicting local port assignments before initialization.
