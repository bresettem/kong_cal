// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
// Custom for Dark Admin
import "./custom/front"
import "./custom/just-validate.min"
import "./custom/Chart.min"
import "./custom/choices.min"

// Custom js
import "./custom/days_until"
// import "./custom/charts-home"
import "@fortawesome/fontawesome-free/js/fontawesome"
import "@fortawesome/fontawesome-free/js/solid"

// Popover
let popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
let popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl)
})

function injectSvgSprite(path) {

    var ajax = new XMLHttpRequest();
    ajax.open("GET", path, true);
    ajax.send();
    ajax.onload = function (e) {
        var div = document.createElement("div");
        div.className = 'd-none';
        div.innerHTML = ajax.responseText;
        document.body.insertBefore(div, document.body.childNodes[0]);
    }
}

// this is set to BootstrapTemple website as you cannot
// inject local SVG sprite (using only 'icons/orion-svg-sprite.svg' path)
// while using file:// protocol
// pls don't forget to change to your domain :)
// injectSvgSprite('https://bootstraptemple.com/files/icons/orion-svg-sprite.svg');