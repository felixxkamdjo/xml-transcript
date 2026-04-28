"""
transform.py — Transformation XSLT et génération PDF

Usage :
    python3 transform.py
    python3 transform.py --pdf
"""

import os
import sys
import subprocess

BASE     = os.path.dirname(os.path.abspath(__file__))
VENV     = os.path.join(BASE, ".venv")

# Détection du système
if os.name == "nt":
    VPYTHON = os.path.join(VENV, "Scripts", "python.exe")
    VPIP    = os.path.join(VENV, "Scripts", "pip.exe")
else:
    VPYTHON = os.path.join(VENV, "bin", "python3")
    VPIP    = os.path.join(VENV, "bin", "pip")

# Prévention des relances multiples
ALREADY_BOOTSTRAPPED = os.environ.get("_TRANSFORM_BOOTSTRAPPED") == "1"

def bootstrap():
    """Initialise l'environnement virtuel et installe les dépendances."""
    if not os.path.isdir(VENV):
        print("[setup] Création du virtualenv...")
        subprocess.check_call([sys.executable, "-m", "venv", VENV])

    print("[setup] Installation des dépendances...")
    subprocess.check_call([VPIP, "install", "--quiet", "lxml", "weasyprint"])

    print("[setup] Environnement prêt.")
    env = os.environ.copy()
    env["_TRANSFORM_BOOTSTRAPPED"] = "1"
    result = subprocess.run([VPYTHON] + sys.argv, env=env)
    sys.exit(result.returncode)

# Initialisation si nécessaire
if not ALREADY_BOOTSTRAPPED:
    venv_ok = os.path.isdir(VENV) and os.path.isfile(VPYTHON)
    try:
        import lxml  # noqa: F401
        lxml_ok = True
    except ImportError:
        lxml_ok = False

    if not lxml_ok:
        bootstrap()

# Import principal
try:
    from lxml import etree
except ImportError:
    print("[erreur] lxml introuvable après initialisation.")
    sys.exit(1)

# Chemins
XML     = os.path.join(BASE, "xml",    "transcript.xml")
XSL     = os.path.join(BASE, "xslt",   "transcript.xsl")
CSS     = os.path.join(BASE, "css",    "transcript.css")
OUT     = os.path.join(BASE, "output", "index.html")
OUT_PDF = os.path.join(BASE, "output", "transcript.pdf")

os.makedirs(os.path.join(BASE, "output"), exist_ok=True)

# Transformation XSLT en HTML
print("[transform] Chargement du XML...")
xml_doc  = etree.parse(XML)

print("[transform] Chargement du XSLT...")
xslt_doc = etree.parse(XSL)

print("[transform] Transformation en cours...")
result = etree.XSLT(xslt_doc)(xml_doc)

with open(OUT, "wb") as f:
    f.write(etree.tostring(result, pretty_print=True, encoding="UTF-8"))

print(f"[transform] OK → {OUT}")

# Génération PDF
if "--pdf" in sys.argv:
    try:
        from weasyprint import HTML, CSS as WeasyCss
    except ImportError:
        print("[erreur] weasyprint introuvable.")
        sys.exit(1)

    print("[pdf] Génération en cours...")
    HTML(filename=OUT, base_url=os.path.dirname(OUT)).write_pdf(
        OUT_PDF, stylesheets=[WeasyCss(filename=CSS)]
    )
    print(f"[pdf] OK → {OUT_PDF}")
else:
    print("[info] Ouvrez output/index.html dans votre navigateur.")
    print("[info] PDF : python3 transform.py --pdf")