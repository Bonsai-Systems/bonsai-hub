# Bonsai Hub

Shared admin library for the Bonsai plugin suite. It gives every Bonsai plugin one home in wp-admin:

- A top-level **Bonsai** menu, with a submenu item per plugin.
- A shared page shell: Bonsai header, a left-hand nav listing every Bonsai plugin, and tabs across the top for each plugin's sections.
- A built-in **Plugins** screen that lists the whole suite and installs, activates and deactivates each plugin from its latest GitHub release.

The hub isn't a plugin. Each Bonsai plugin bundles a copy in `lib/bonsai-hub/`, so installing any one of them sets up the menu. When several plugins bundle different versions, only the newest copy loads.

## Adding the hub to a plugin

1. Copy the library in:

   ```bash
   bonsai-hub/bin/sync.sh bonsai-my-plugin
   ```

2. Load it from the main plugin file, before any hooks run:

   ```php
   require_once plugin_dir_path( __FILE__ ) . 'lib/bonsai-hub/bonsai-hub.php';
   ```

3. Register the plugin as a module:

   ```php
   add_filter( 'bonsai_hub_modules', 'bmp_register_hub_module' );
   function bmp_register_hub_module( $modules ) {
   	$modules['bonsai-my-plugin'] = array(     // Admin page slug: admin.php?page=bonsai-my-plugin
   		'label'       => __( 'My Plugin', 'bonsai-my-plugin' ),
   		'title'       => __( 'Bonsai My Plugin', 'bonsai-my-plugin' ),
   		'description' => __( 'One line about what it does.', 'bonsai-my-plugin' ),
   		'version'     => BMP_VERSION,
   		'repo'        => 'https://github.com/Bonsai-Systems/bonsai-my-plugin',
   		'capability'  => 'manage_options',
   		'enqueue'     => 'bmp_admin_enqueue', // Receives the current tab slug.
   		'tabs'        => array(
   			'settings' => array(
   				'label'  => __( 'Settings', 'bonsai-my-plugin' ),
   				'render' => 'bmp_render_settings_tab',
   			),
   			'help'     => array(
   				'label'  => __( 'Help', 'bonsai-my-plugin' ),
   				'render' => 'bmp_render_help_tab',
   			),
   		),
   	);
   	return $modules;
   }
   ```

4. Remove the plugin's own `add_options_page()` / `add_management_page()` call, its copy of `bonsai-admin-ui.css` and avatar, and its header function. The hub prints the wrap, header, notices, nav and tabs; render callbacks print only their own content.

5. Add the plugin to the catalogue in `includes/class-bonsai-hub-installer.php` if it's new to the suite.

Old links such as `options-general.php?page=bonsai-my-plugin` redirect to the new screen automatically, as long as the module keeps the same page slug.

### Module options

| Key | Required | Notes |
|---|---|---|
| `label` | Yes | Submenu and left nav label. |
| `title` | | Header title. Defaults to `label`. |
| `description` | | Header lead. Allows `a`, `code`, `strong`, `em`. |
| `version` | | Shown in the header badge. |
| `repo` | | GitHub URL. Adds GitHub and Changelog links to the header. |
| `links` | | Extra header links, shown first: `[ [ 'label' => '', 'url' => '' ] ]`. |
| `capability` | | Defaults to `manage_options`. |
| `position` | | Sort order (default 10, then alphabetical). |
| `tabs` | Yes, or `render` | `slug => [ label, render, description?, capability?, load? ]`. The tab bar is hidden when only one tab is visible. |
| `render` | | Shorthand for a single screen with no tab bar. |
| `enqueue` | | Callback for admin assets on this screen only. Receives the tab slug. |
| `load` | | Runs on `load-{hook}` before output, e.g. to handle a form and redirect. Tabs can have their own. |
| `legacy` | | Old page slugs merged into a tab: `[ 'old-slug' => 'tab' ]`. Their old URLs redirect to that tab. |

**Link tabs.** A tab with `url` instead of `render` links to another admin screen, such as a post type list (Site Snags' **All snags**). It's never the default tab, and a user who can only see link tabs is sent straight to the first one.

**Saving.** Settings API forms (`options.php`) get core's "Settings saved." notice as normal. A plugin saving through its own `admin-post.php` handler only needs to redirect back with `settings-updated=true`; the hub adds the notice. If tabs share one Settings API option group, saving one tab blanks the others' fields, so give each tab its own group (see Maintenance Mode).

### Helpers

- `Bonsai_Hub::url( $page, $tab = '', $args = array() )` builds a hub screen URL. Call it from hooks, not at file load: the hub boots on `plugins_loaded`.
- Filters: `bonsai_hub_modules`, `bonsai_hub_catalogue`, `bonsai_hub_menu_icon` (default `dashicons-layout`), `bonsai_hub_menu_first` (default true: Bonsai is forced to the top of the sidebar, above Dashboard) and `bonsai_hub_menu_position` (default 1, used when `bonsai_hub_menu_first` is false).

## Releasing a hub change

1. Make the change here and bump `$bonsai_hub_candidate_version` in `bonsai-hub.php`.
2. Add a CHANGELOG entry.
3. Run `bin/sync.sh` to update every plugin that bundles the hub.
4. Release each plugin as normal, with `lib/` included in the zip. Sites pick up the new hub as soon as any one of their Bonsai plugins updates.

Keep the module API backwards compatible: older plugins keep registering with whatever hub version is newest on the site.

## Licence

GPL-2.0-or-later
