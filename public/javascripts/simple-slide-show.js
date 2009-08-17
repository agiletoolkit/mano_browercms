var delay = 3000;
var start_frame = 0;
var containerName = 'slides'

function init() {
  var slideContainer = $(containerName); 

  if (!slideContainer) {
    return;
  }

  if (slideContainer.className == 'testimonial') {
    delay = 15000;
  }

  var lis = slideContainer.getElementsByTagName('li');
	
  for(var i=0; i < lis.length; i++){
	if(i!=0){
		lis[i].style.display = 'none';
	}
  }
  
  end_frame = lis.length -1;
  
  start_slideshow(start_frame, end_frame, delay, lis);	
}

function start_slideshow(start_frame, end_frame, delay, lis) {
	setTimeout(fadeInOut(start_frame,start_frame,end_frame, delay, lis), delay);
}

function fadeInOut(frame, start_frame, end_frame, delay, lis) {
	return (function() {
		lis = $(containerName).getElementsByTagName('li');
		Effect.Fade(lis[frame]);
		if (frame == end_frame) { frame = start_frame; } else { frame++; }
		lisAppear = lis[frame];
		setTimeout("Effect.Appear(lisAppear);", 0);
		setTimeout(fadeInOut(frame, start_frame, end_frame, delay), delay + 1850);
	})
	
}

Event.observe(window, 'load', init, false);