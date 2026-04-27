# Projet XML — Bulletin de notes académique

**Cours :** Introduction au langage XML
**Type :** Projet individuel

---

## Contexte

Dans le cadre du cours d'Introduction au langage XML, il nous a été demandé de réaliser, en respectant toutes les bonnes pratiques du langage, la modélisation XML d'un document réel au choix : bulletin de notes, facture.

Pour ce projet, j'ai choisi de reproduire un **bulletin de notes académique** dont j'ai trouvé le modèle sur Pinterest. Le modèle original (image de référence) est inclus dans le dossier `assets/` du projet afin d'illustrer la fidélité de la reproduction.

Le document choisi est un relevé de notes officiel délivré par le *Board of Intermediate and Secondary Education, Chattogram (Bangladesh)* pour l'examen *Secondary School Certificate 2022*. Ce choix s'est imposé pour la richesse de sa structure : en-tête institutionnel, barème de notation, données personnelles, tableau de matières avec calcul de GPA, et sections distinctes (obligatoire, optionnel, évaluation continue).

---

## Technologies mises en œuvre

| Technologie | Version | Rôle |
|-------------|---------|------|
| XML | 1.0 | Structuration et stockage des données |
| DTD | — | Définition de la grammaire et validation |
| XSLT | 1.0 | Transformation XML → HTML |
| CSS | 3 | Mise en forme visuelle du rendu |
| HTML | 5 | Document final lisible dans un navigateur |

---

## Architecture du projet

```
academic-transcript/
│
├── xml/
│   └── transcript.xml          # Document XML principal (données)
│
├── dtd/
│   └── transcript.dtd          # Définition de la structure (validation)
│
├── xslt/
│   └── transcript.xsl          # Feuille de transformation XSLT 1.0
│
├── css/
│   └── transcript.css          # Feuille de style CSS3
│
├── assets/
│   └── model.jpg               # Modèle original trouvé sur Pinterest
│
├── output/
│   └── index.html              # Rendu HTML final (ouvrir dans un navigateur)
│
├── Makefile                    # Automatisation des commandes
└── README.md                   # Ce fichier
```

---

## Description des fichiers

### `xml/transcript.xml`

Fichier source central du projet. Il contient l'intégralité des données du relevé de notes : informations de l'établissement émetteur, barème de notation complet (A+ → F), données personnelles de l'étudiant(e), liste des matières avec notes et points GPA, et résultats globaux.

Il déclare sa DTD via `<!DOCTYPE academic_transcript SYSTEM "../dtd/transcript.dtd">` et appelle la feuille XSLT via l'instruction de traitement `<?xml-stylesheet ?>`.

### `dtd/transcript.dtd`

Document Type Definition définissant la grammaire formelle du document XML. Il spécifie les éléments autorisés et leur ordre (`ELEMENT`), les attributs et leurs types (`ATTLIST`) avec les mots-clés `#REQUIRED`, `#IMPLIED`, `#FIXED`, et les cardinalités (`+`, `*`, `?`) garantissant la cohérence des données.

### `xslt/transcript.xsl`

Feuille de transformation XSLT 1.0 qui convertit le XML en HTML5. Elle utilise `<xsl:apply-templates>` pour la traversée récursive, `<xsl:for-each>` pour l'itération, `<xsl:value-of>` pour l'extraction des valeurs, et `<xsl:choose>/<xsl:when>` pour la logique conditionnelle.

### `css/transcript.css`

Feuille de style CSS3 reproduisant fidèlement la mise en page du document original : double bordure décorative, flexbox, tableau avec cellules GPA fusionnées, typographie serif académique, et règles `@media print`.

### `output/index.html`

Rendu HTML statique pré-généré par la transformation XSLT. Peut être ouvert directement dans n'importe quel navigateur sans aucun outil supplémentaire.

> **Note :** Les navigateurs modernes bloquent l'exécution XSLT depuis `file://` pour des raisons de sécurité. Le fichier `output/index.html` est donc fourni pré-transformé pour contourner cette contrainte.

### `assets/model.jpg`

Image du modèle original utilisé comme référence visuelle pour la reproduction.

---

## Installation et utilisation

### Prérequis

**Debian/Ubuntu :**
```bash
sudo apt-get update
sudo apt-get install xsltproc libxml2-utils make
```

**Windows :**

Plusieurs options selon l'environnement disponible :

- **WSL (recommandé)** — Windows Subsystem for Linux, puis mêmes commandes que Debian
- **Chocolatey :**
  ```powershell
  choco install xsltproc
  ```
- **Saxon HE (Java)** — télécharger sur [saxonica.com](https://www.saxonica.com/download/java.xml), puis :
  ```bat
  java -jar saxon-he.jar -s:xml\transcript.xml -xsl:xslt\transcript.xsl -o:output\index.html
  ```
- **Python 3 + lxml (universel, aucune installation système requise) :**
  ```bat
  pip install lxml
  python transform.py
  ```

---

### Option 1 — Via Makefile (recommandé)

```bash
# Transformer XML en HTML et ouvre le résultat
make all

# Transformer XML en HTML uniquement
make build

# Valider le XML contre la DTD
make validate

# Ouvrir le rendu dans le navigateur
make open

# Nettoyer les fichiers générés
make clean
```

### Option 2 — Ligne de commande directe

**Debian/Linux/macOS :**
```bash
xsltproc xslt/transcript.xsl xml/transcript.xml > output/index.html
```

**Windows (Saxon HE) :**
```bat
java -jar saxon-he.jar -s:xml\transcript.xml -xsl:xslt\transcript.xsl -o:output\index.html
```

**Python 3 (universel) :**
```bash
python3 transform.py
```

### Option 3 — Rendu direct sans outil

Ouvrir directement `output/index.html` dans un navigateur (double-clic ou `Ctrl+O`). Le fichier est pré-généré et ne nécessite aucun outil.

---

## Validation DTD

```bash
# Debian/Linux
xmllint --valid --noout xml/transcript.xml

# Via Makefile
make validate
```

Un retour silencieux indique que le document est **bien formé et valide**.

---

*Projet individuel — Introduction au langage XML*