import star_on_img from "./images/star-on.png";
import star_off_img from "./images/star-off.png";
import star_half_img from "./images/star-half.png";

document.addEventListener('turbolinks:load', function () {
  const elem = document.querySelector('#post_raty');
  if (!elem || typeof raty !== "function") {
    console.warn("raty not loaded or element not found");
    return;
  }
  raty(elem, {
    starOn: star_on_img,
    starOff: star_off_img,
    starHalf: star_half_img,
    scoreName: "item[star]",
    score: parseInt(elem.dataset.score) || 0,
    click: function (score) {
      document.getElementById('item_star').value = score;
    }
  });
});
