## Generate/update the `icon-sprite.svg` file

1. Export SVG icon from Figma.

2. Add icon file to `assets/static/images/icons/` (without the `icon-` prefix).

3. Generate/Update the `icon-sprite.svg` by running this command:

  ```sh
  npm run svg-sprite.generate-icon --prefix assets
  ```

## Using Icon Sprite in Template

```sh
<%= icon_tag(@conn, "icon-active", class: "something") %>
# <svg class=\"something icon\"><use xlink:href=\"/images/icon-sprite.svg#icon-active\"></svg>
```
