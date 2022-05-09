## Generate/update the `icon-sprite.svg` file

1. Export SVG icon from Figma.

2. Add icon file to `priv/static/images/icons/` (without the `icon-` prefix) (e.g. `active.svg`).

3. Generate/Update the `icon-sprite.svg` by running this command:
   ```sh
   npm run svg-sprite.generate-icon --prefix assets
   ```

## Using Icon Sprite in Template

```sh
<%= icon_tag(@conn, "active", class: "something") %>

# <svg class=\"icon something\"><use xlink:href=\"/images/icon-sprite.svg#icon-priv--static--images--icons--active\"></svg>
```
