function scan(file){
    if(busy) return;
    busy = true;
    showOverlay("Готовим фото…", "Держите VIN целиком в кадре");
    var canvas = null;
    btnCam.disabled = true;
    btnGal.disabled = true;

    fileToCanvas(file).then(function(c){
      canvas = c;
      return recognize(canvas, "7");
    }).then(function(data){
      var cands = findCandidates(data.text || "");
      hideOverlay();
      showResult(cands.map(function(c){ return c.vin; }), data.confidence || 0, cands);
    }).catch(function(err){
      hideOverlay();
      showResult([], 0, [], (err && err.message) || "Не удалось обработать фото");
    }).then(function(){
      busy = false;
      btnCam.disabled = false;
      btnGal.disabled = false;
    });
  }
