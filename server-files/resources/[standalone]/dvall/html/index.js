$(function () {
  function display(bool) {
      if (bool) {
          $("#container").fadeToggle(3000);
      } else {
          $("#container").hide();
      }
  }


  function timer(){
var minutes = 1
var seconds = 0
var asecondes= 600
var myInterval = setInterval(function() {

var distance = asecondes-1;

// Time calculations for days, hours, minutes and seconds
var secondstr
var minutestr
if(seconds<1){
  secondstr= "0"+ seconds;
}
else{
  secondstr= seconds
}
  minutestr= minutes
seconds--;
if(seconds<0){
  seconds= 59
  minutes--
}
if(minutes==0){
  document.getElementById("h1").style.color = "#b1b395";
}

if(10>seconds){
    seconds= "0" + seconds
  
  }
  if(1>minutes){
    minutes= "00"
  
  }
// Display the result in the element with id="h1"
document.getElementById("h1").innerHTML =minutestr + ":" + secondstr;

// If the count down is finished, write some text

if (seconds == 0) {
  document.getElementById("h1").innerHTML = "DONE";
  $("#container").fadeToggle(2000);
  clearInterval(myInterval);
      
}
}, 1000);
  }

  const sleep = (milliseconds) => {
      return new Promise(resolve => setTimeout(resolve, milliseconds))
   }

  

  window.addEventListener('message', function(event) {
      var item = event.data;
      if (item.type === "ui") {
          if (item.status == true) {
              display(true)
          } else {
              display(false)
          }
      }
      else if(item.type === "changeTime"){
              display(true)
              timer()
              
      }
  })

  display(false)


  
  // if the person uses the escape key, it will exit the resource
  document.onkeyup = function (data) {
      if (data.which == 27) {
          $.post('http://dvall/exit', JSON.stringify({}));
          return
      }
  };
  $("#close").click(function () {
      $.post('http://dvall/exit', JSON.stringify({}));
      return
  })

  //when the user clicks on the submit button, it will run
  $("#submit").click(function () {
      let inputValue = $("#input").val()
      if (inputValue.length >= 100) {
          $.post("http://dvall/error", JSON.stringify({
              error: "Input was greater than 100"
          }))
          return
      } else if (!inputValue) {
          $.post("http://dvall/error", JSON.stringify({
              error: "There was no value in the input field"
          }))
          return
      }
      // if there are no errors from above, we can send the data back to the original callback and hanndle it from there
      $.post('http://dvall/main', JSON.stringify({
          text: inputValue,
      }));
      return;
  })
})