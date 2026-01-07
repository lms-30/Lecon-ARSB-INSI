# Injection de commandes avant authentification dans remote_agent.php de Cacti (CVE-2022-46169)

Cacti est un framework robuste et extensible de surveillance opérationnelle et de gestion des pannes destiné aux utilisateurs du monde entier. Une vulnérabilité d'injection de commandes permet à un utilisateur non authentifié d'exécuter du code arbitraire sur un serveur exécutant Cacti avant la version 1.2.17 à la version 1.2.22, si une source de données spécifique a été sélectionnée pour un périphérique surveillé.

Références :

- [https://github.com/Cacti/cacti/security/advisories/GHSA-6p93-p743-35gf](https://github.com/Cacti/cacti/security/advisories/GHSA-6p93-p743-35gf)
- [https://mp.weixin.qq.com/s/6crwl8ggMkiHdeTtTApv3A](https://mp.weixin.qq.com/s/6crwl8ggMkiHdeTtTApv3A)

# Injection SQL dans Cacti graph_view.php permettant une exécution de code à distance (CVE-2023-39361/CVE-2024-31459)

[](https://github.com/vulhub/vulhub/tree/master/cacti/CVE-2023-39361#cacti-graph_viewphp-sql-injection-leads-to-rce-cve-2023-39361cve-2024-31459)

[中文版本 (version chinoise)](https://github.com/vulhub/vulhub/blob/master/cacti/CVE-2023-39361/README.zh-cn.md)

Cacti est une solution complète de représentation graphique de réseaux conçue pour exploiter la puissance des fonctionnalités de stockage et de représentation graphique des données de RRDTool, offrant aux administrateurs réseau une interface intuitive pour les données réseau.

Dans les versions 1.2.24 et antérieures de Cacti, une vulnérabilité critique du fichier graph_view.php permet aux utilisateurs invités d'effectuer des injections SQL via le paramètre « rfilter ». Lorsque l'accès invité est activé, les attaquants peuvent potentiellement causer des dommages importants, y compris l'exécution de code à distance.

Références :

- [https://github.com/Cacti/cacti/security/advisories/GHSA-6r43-q2fw-5wrg](https://github.com/Cacti/cacti/security/advisories/GHSA-6r43-q2fw-5wrg)
- [https://github.com/Cacti/cacti/security/advisories/GHSA-cx8g-hvq8-p2rv](https://github.com/Cacti/cacti/security/advisories/GHSA-cx8g-hvq8-p2rv)

# Injection d'arguments post-authentification dans Cacti RRDTool : vulnérabilité permettant l'exécution de code à distance (CVE-2025-24367)

[](https://github.com/vulhub/vulhub/tree/master/cacti/CVE-2025-24367#cacti-rrdtool-post-auth-argument-injection-leads-to-rce-cve-2025-24367)

[中文版本 (version chinoise)](https://github.com/vulhub/vulhub/blob/master/cacti/CVE-2025-24367/README.zh-cn.md)

Cacti est une solution complète de représentation graphique de réseaux conçue pour exploiter la puissance des fonctionnalités de stockage et de représentation graphique de RRDTool. Les versions de Cacti jusqu'à la version 1.2.28 présentent une vulnérabilité d'injection d'arguments permettant à des utilisateurs authentifiés de créer des fichiers PHP arbitraires sur le serveur web, ce qui peut potentiellement mener à l'exécution de code à distance.

La vulnérabilité réside dans la fonctionnalité de modèle de graphe, où les entrées utilisateur pour les paramètres de commande RRDTool, tels que `<commande>`, `--right-axis-label`ne sont pas correctement filtrées. Bien que Cacti tente d'échapper les métacaractères du shell à l'aide de `cacti_escapeshellarg()``<commande>`, il ne gère pas les caractères de nouvelle ligne. Cela permet à un attaquant de s'extraire du contexte de commande prévu et d'injecter des commandes RRDTool supplémentaires, ce qui lui permet d'écrire des fichiers PHP malveillants à la racine du site web.

Références :

- [https://github.com/Cacti/cacti/security/advisories/GHSA-fxrq-fr7h-9rqq](https://github.com/Cacti/cacti/security/advisories/GHSA-fxrq-fr7h-9rqq)
- [https://github.com/Cacti/cacti/commit/c7e4ee798d263a3209ae6e7ba182c7b65284d8f0](https://github.com/Cacti/cacti/commit/c7e4ee798d263a3209ae6e7ba182c7b65284d8f0)

