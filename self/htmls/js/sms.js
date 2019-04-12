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

    var inpt = document.getElementById( 'password' );
    var cancel = document.getElementsByClassName( 'cancel_pay' )[0];
    var info = document.getElementsByClassName( 'info' )[0];

    info.style.display = 'none';
    inpt.addEventListener("focus", function (e) {
        inpt.placeholder = "";
        cancel.style.display = 'none';
        info.style.display = 'none';
    });

    inpt.addEventListener("blur", function (e) {
        inpt.placeholder = "Код из SMS";
        cancel.style.display = 'block';
        info.style.display = 'none';
    });
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
    var text = "Повторно код можно будет отправить<br>через " + sec + " сек.";

    relink.style.display = "none";
    retext.style.display = "block";
    retext.innerHTML = text;

    setTimeout(function () {
        sec--;
        tickToResentSMS(sec);
    }, 1000)
}