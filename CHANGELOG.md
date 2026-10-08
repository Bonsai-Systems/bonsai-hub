# Changelog

All notable changes to Bonsai Hub are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.2] - 2026-10-08

### Added
- Bonsai Post Expiry in the Plugins catalogue.

## [1.0.1] - 2026-10-05

### Changed
- Bonsai admin menu now sits directly below Dashboard instead of above it. Default menu position is 3 (was 1).
- `bonsai_hub_menu_first` filter renamed to `bonsai_hub_menu_below_dashboard`.

## [1.0.0] - 2026-10-03

### Added
- Top-level Bonsai admin menu (`dashicons-layout` icon), kept first in the sidebar above Dashboard, with a submenu item per registered plugin.
- Shared page shell: Bonsai header, left-hand plugin nav and per-plugin tab bar.
- `bonsai_hub_modules` filter for plugins to register their screens and tabs, with per-tab descriptions and capabilities, extra header links, link tabs to other admin screens, and `legacy` redirects for old screens merged into a tab.
- "Settings saved." notice for plugins that save through their own `admin-post.php` handler and redirect with `settings-updated`.
- Print styles that hide the nav and tab bar, for printable screens such as SEO/GEO Checker's PDF reports.
- Plugins screen listing the suite, with install from the latest GitHub release, activate, deactivate and open.
- Redirects from old settings URLs (e.g. `options-general.php?page=…`) to the new hub screens.
- Highest-version-wins loader so plugins bundling different hub versions don't clash.
- `bin/sync.sh` to copy the library into each plugin's `lib/bonsai-hub/`.
- Canonical `bonsai-admin-ui.css` design system and avatar, moved here from bonsai-seo-geo-checker.
