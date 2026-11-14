#!/usr/bin/env python3
"""One-pass checks for the static Pages site."""
import json
import sys
import xml.etree.ElementTree as ET
from html.parser import HTMLParser
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "site"
BASE = "https://shalimoosavi.github.io/SYJ-RE-Workstation"
PAGES = [ROOT/"index.html", ROOT/"install/index.html", ROOT/"usage/index.html", ROOT/"faq/index.html", ROOT/"about/index.html", ROOT/"roadmap/index.html"]
errors = []
class Check(HTMLParser):
    def __init__(self):
        super().__init__()
        self.ids, self.links, self.schemas = set(), [], []
        self.script = False
        self.data = ""
        self.h1 = 0
        self.lang = self.title = self.description = False
    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        if tag == "html" and a.get("lang") == "en": self.lang = True
        if tag == "h1": self.h1 += 1
        if a.get("id"): self.ids.add(a["id"])
        if tag == "a" and a.get("href"): self.links.append(a["href"])
        if tag == "title": self.title = True
        if tag == "meta" and a.get("name") == "description" and a.get("content"): self.description = True
        if tag == "script" and a.get("type") == "application/ld+json": self.script = True
    def handle_endtag(self, tag):
        if tag == "script" and self.script:
            self.schemas.append(self.data)
            self.data, self.script = "", False
    def handle_data(self, data):
        if self.script: self.data += data

parsers = {}
for path in PAGES:
    if not path.is_file():
        errors.append(f"Missing page: {path}"); continue
    p = Check(); p.feed(path.read_text(encoding="utf-8")); parsers[path] = p
    if not p.lang: errors.append(f"{path}: lang=en missing")
    if p.h1 != 1: errors.append(f"{path}: expected one H1, got {p.h1}")
    if not p.title or not p.description: errors.append(f"{path}: title or meta description missing")
    for schema in p.schemas:
        try: json.loads(schema)
        except json.JSONDecodeError as exc: errors.append(f"{path}: invalid JSON-LD: {exc}")
for path, parser in parsers.items():
    for href in parser.links:
        if href.startswith(("https://","http://","mailto:","#")): continue
        target, _, anchor = href.partition("#")
        target = target.split("?",1)[0]
        if not target: continue
        candidate = (path.parent / target).resolve()
        if candidate.is_dir(): candidate = candidate / "index.html"
        if not candidate.is_file(): errors.append(f"{path}: broken link {href}")
        elif anchor and candidate in parsers and anchor not in parsers[candidate].ids: errors.append(f"{path}: missing anchor {href}")
try:
    urls = [n.text for n in ET.parse(ROOT/"sitemap.xml").findall(".//{*}loc")]
    expected = {BASE+"/",BASE+"/install/",BASE+"/usage/",BASE+"/faq/",BASE+"/about/",BASE+"/roadmap/"}
    if set(urls) != expected: errors.append("sitemap URLs do not match published pages")
except (OSError, ET.ParseError) as exc: errors.append(f"sitemap parse error: {exc}")
if errors:
    print("\n".join(errors)); sys.exit(1)
print(f"PASS: {len(parsers)} pages, JSON-LD parses, local links and sitemap checked.")
