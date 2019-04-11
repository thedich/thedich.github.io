document.addEventListener( "DOMContentLoaded", listenSMSInput );

function listenSMSInput () {
    var sms = document.getElementById( 'password' );
    sms.addEventListener( 'keyup', function ( ev ) {
        var len = this.value.toString().length;
        if ( len >= 4 ) {
            submitSms();
        }
    } );

    tickToResentSMS();
}

function submitSms () {
    document.getElementById( 'sendSms' ).value = 'true';
    document.forms[ 0 ].submit();
}

function tickToResentSMS ( seconds ) {

    var relink = document.getElementsByClassName( 'resend_link' )[0];
    var retext = document.getElementsByClassName( 'text_resent' )[0];

    if(seconds === 0)
    {
        relink.style.display = "block";
        retext.style.display = "none";
        relink.addEventListener("click", function (e) {
            tickToResentSMS();
        });

        return;
    }

    var sec = seconds || 15;
    var text = "Повторно код можно будет отправить через " + sec + " сек.";

    relink.style.display = "none";
    retext.style.display = "block";
    retext.innerHTML = text;

    setTimeout(function () {
        sec--;
        tickToResentSMS(sec);
    }, 1000)
}