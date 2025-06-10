document.addEventListener('turbolinks:load', function () {
  const elem = document.querySelector('#post_raty');
  if (!elem || typeof raty !== "function") {
    console.warn("raty not loaded or element not found");
    return;
  }

  raty(elem, {
    starOn: "/assets/images/star-on.png",
    starOff: "/assets/images/star-off.png",
    starHalf: "/assets/images/star-half.png",
    scoreName: "item[star]",
    score: parseInt(elem.dataset.score) || 0,
    click: function (score) {
      document.getElementById('item_star').value = score;
    }
  });
});
