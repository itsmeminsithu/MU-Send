#!/usr/bin/env python3
"""Serve the MU Send web app locally. Camera (QR scan) works on http://localhost;
on other devices use the Copy/Paste code option, or set up HTTPS."""
import http.server, socket, sys, os
PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
os.chdir(os.path.dirname(os.path.abspath(__file__)))
def lan_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try: s.connect(('8.8.8.8', 80)); ip = s.getsockname()[0]
    except Exception: ip = '127.0.0.1'
    finally: s.close()
    return ip
httpd = http.server.HTTPServer(('0.0.0.0', PORT), http.server.SimpleHTTPRequestHandler)
print('\nMU Send is running:')
print(f'  This device : http://localhost:{PORT}   (camera works here)')
print(f'  Same Wi-Fi  : http://{lan_ip()}:{PORT}   (use Copy/Paste code)')
print('\nOpen index.html at those URLs. Ctrl+C to stop.\n')
try: httpd.serve_forever()
except KeyboardInterrupt: print('\nStopped.')
