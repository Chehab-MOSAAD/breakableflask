# Image Python légère
FROM python:3.11-slim

# Bonnes pratiques Python
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Mise à jour minimale + outils de build si besoin
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

# Répertoire de travail
WORKDIR /app

# On copie d'abord les dépendances (cache Docker)
COPY requirements.txt .

# Installation des dépendances
RUN pip install --no-cache-dir -r requirements.txt

# Puis le code de l’appli
COPY . .

# Création d’un user non-root
RUN useradd -r -u 1001 appuser && chown -R appuser /app
USER appuser

# L’appli écoute sur le port 4000 (cf. README du projet)
EXPOSE 4000

# Commande de lancement
CMD ["python", "main.py"]
