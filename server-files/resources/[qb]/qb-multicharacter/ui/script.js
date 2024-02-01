const dots = document.querySelectorAll('.dot');
var cidnumber = null
var selectedgender = null
var allah = null

$(".dot").each(function(){
    $(this).click(function(){
        $('#characterAvailable').css('display', 'none');
        $('#characterCreate').css('display', 'none');
        $(".selected").each(function(){
            $(this).removeClass('selected');
        });

        $(this).addClass('selected');
        var slot = $('.selected').attr("data-slot");
        cidnumber = Number(slot); 
        naberKankalar(cidnumber); 
    });
});

$(document).ready(function() {
    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.open == true) {
            $(".selected").each(function(){
                $(this).removeClass('selected');
            });
    
            $('.dot[data-slot="1"]').addClass('selected');
                naberKankalar(1);
                container.style.display = 'flex';

        } else if (item.open == false) {
            container.style.display = 'none';
        }
    });
})

function naberKankalar(cidnumber) {
    $.post('https://qb-multicharacter/getCharacterbyCid', JSON.stringify({
    number: cidnumber
    }), function(cb) {
        if (cb != null) {
            allah = cb.citizenid
            $(".character-text").html(cb.charinfo.firstname + " " + cb.charinfo.lastname)
            $(".character-citizen").html("#" + cb.citizenid)
            let gendertext = "Male"
            if(cb.charinfo.gender == 0) {
                gendertext = "Male"
            } else if(cb.charinfo.gender == 1) {
                gendertext = "Female"
            } else {
                gendertext = "LGBTQ"
            }
            $("#gender").html(gendertext)
            $("#dob").html(cb.charinfo.birthdate)
            $("#cash").html(cb.money.cash)
            $("#bank").html(cb.money.bank)
            $("#phonenum").html(cb.charinfo.phone)
            $("#nationality").html(cb.charinfo.nationality)
            $("#job").html(cb.job.label)
            $("#olusum").html(cb.gang.label)
            // $("#job").html(cb.job.label)
            $('#characterAvailable').fadeIn();
            $.post('https://qb-multicharacter/cDataPed', JSON.stringify({
                citizenid: cb.citizenid
            }));
        } else {
            $('#characterCreate').fadeIn();
            $(".character-text").html('? ?')
            $(".character-citizen").html("#CITIZENID")
            $.post('https://qb-multicharacter/cDataPed', JSON.stringify({
                citizenid: null
            }));
        }
 })
}


$(function() {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
})

$(document).ready(function() {
    $('#fname, #sname').on('input', function() {
      var fnameValue = $('#fname').val().substring(0, 8);
      var snameValue = $('#sname').val().substring(0, 7);
      
      if (fnameValue === "") {
        fnameValue = "?";
      }
      
      if (snameValue === "") {
        snameValue = "?";
      }
  
      $('#selamlar').text(fnameValue + ' ' + snameValue);
    });
  });

  function escapeHtml(string) {
    return String(string).replace(/[&<>"'=/]/g, function (s) {
        return entityMap[s];
    });
}
function hasWhiteSpace(s) {
    return /\s/g.test(s);
  }
$(document).ready(function () {

  $(document).on('click', '#createcharacter', function (e) {
    e.preventDefault();
    console.log(cidnumber)
        let firstname= escapeHtml($('#fname').val())
        let lastname= escapeHtml($('#sname').val())
        let nationality= escapeHtml($('#nationalitys').val())
        let birthdate= escapeHtml($('#birthday').val())
        let gender = escapeHtml(selectedgender)
        console.log(nationality, birthdate, firstname, lastname, gender)
        

    if (!firstname || !lastname || !nationality|| !birthdate || hasWhiteSpace(firstname) || hasWhiteSpace(lastname)){
    console.log("FIELDS REQUIRED")
    }else{
        $("#container").hide();
        $('#characterAvailable').css('display', 'none');
        $('#characterCreate').css('display', 'none');
        $.post('https://qb-multicharacter/createNewCharacter', JSON.stringify({
            firstname: firstname,
            lastname: lastname,
            nationality: nationality,
            birthdate: birthdate,
            gender: gender,
            cid: cidnumber,
        }));
        cidnumber = null
        $('#fname').val('')
        $('#sname').val('')
        $('#nationalitys').val('')
        $('#birthday').val('')
        female.style.opacity = 1;
        male.style.opacity = 1;
    }
});
});

const myButton = document.getElementById('delete31');
$(document).ready(function () {
myButton.addEventListener('dblclick', () => {
    $.post('https://qb-multicharacter/removeCharacter', JSON.stringify({
      citizenid: allah,
  }));
  cidnumber = null
  $('#fname').val('')
  $('#sname').val('')
  $('#nationalitys').val('')
  $('#birthday').val('')
  female.style.opacity = 1;
  male.style.opacity = 1;
  $("#container").hide();
  $('#characterAvailable').css('display', 'none');
  $('#characterCreate').css('display', 'none');
  $("#container").fadeIn();
  $('#characterCreate').fadeIn();
  });
});

function changeGender(gender) { 
    selectedgender = gender
    if (gender === 'male') {
        female.style.opacity = 1;
        male.style.opacity = 0.6;
    } else if (gender === 'female') {
        male.style.opacity = 1;
        female.style.opacity = 0.6;
    }
}

$(document).ready(function () {

    $(document).on('click', '#play31', function (e) {
        $.post('https://qb-multicharacter/selectCharacter', JSON.stringify({
            citizenid: allah,
        }));
        cidnumber = null
        $('#fname').val('')
        $('#sname').val('')
        $('#nationalitys').val('')
        $('#birthday').val('')
        female.style.opacity = 1;
        male.style.opacity = 1;
        $("#container").hide();
        $('#characterAvailable').css('display', 'none');
        $('#characterCreate').css('display', 'none');
  });
  });