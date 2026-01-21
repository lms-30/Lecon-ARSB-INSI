# Falsification de requête côté serveur dans Apache CXF Aegis DataBinding (CVE-2024-28752)

Apache CXF est un framework de services open source qui vous aide à créer et à développer des services à l'aide d'API de programmation frontend telles que JAX-WS et JAX-RS.

Une vulnérabilité SSRF exploitant l'interface de données Aegis dans les versions d'Apache CXF antérieures à 4.0.4, 3.6.3 et 3.5.8 permet à un attaquant de mener des attaques de type SSRF sur les services web acceptant au moins un paramètre, quel que soit son type. Cette vulnérabilité affecte spécifiquement les services utilisant l'interface de données Aegis, tandis que ceux utilisant d'autres interfaces, y compris celle par défaut, ne sont pas concernés. Les attaquants peuvent exploiter cette vulnérabilité pour accéder aux ressources internes en amenant le serveur à envoyer des requêtes à des URL arbitraires, ce qui peut entraîner la divulgation d'informations ou d'autres attaques contre les systèmes internes.

Références :

- [https://github.com/advisories/GHSA-qmgx-j96g-4428](https://github.com/advisories/GHSA-qmgx-j96g-4428)
- [https://nvd.nist.gov/vuln/detail/CVE-2024-28752](https://nvd.nist.gov/vuln/detail/CVE-2024-28752)
- [https://github.com/ReaJason/CVE-2024-28752](https://github.com/ReaJason/CVE-2024-28752)