(function () {
  var ua = navigator.userAgent || navigator.platform || "";
  var platform = "other";

  if (/Mac/i.test(ua)) platform = "macos";
  else if (/Win/i.test(ua)) platform = "windows";
  else if (/Linux/i.test(ua)) platform = "linux";

  var labels = {
    macos: "macOS detected",
    linux: "Linux detected",
    windows: "Windows detected (support temporarily paused)",
    other: "Could not detect your OS"
  };

  document.addEventListener("DOMContentLoaded", function () {
    var el = document.getElementById("install-" + platform);
    if (el) el.style.display = "block";

    var detector = document.getElementById("detected-os");
    if (detector) detector.textContent = labels[platform] + " \u2014 showing recommended install method.";
  });
})();
