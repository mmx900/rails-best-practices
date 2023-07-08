* HTML 및 ERB 파일의 잠재적인 오류 : [erb-lint](https://github.com/Shopify/erb-lint), [better-html](https://github.com/Shopify/better-html)
    * better-html은 `<nav <% if user_signed_in? %>... >` 같은 문에서 `DontInterpolateHere` 오류가 발생한다. better-html의 [syntax-restriction](https://github.com/Shopify/better-html/blob/main/README.md#syntax-restriction) 참고.
