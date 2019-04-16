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
    var line = document.getElementsByClassName( 'line' )[0];

    info.style.display = 'none';
    inpt.addEventListener("focus", function (e) {
        // cancel.style.display = 'none';

        var isMobile = window.innerWidth < 620;
        isMobile && (cancel.style.display = 'none');

        inpt.placeholder = "";
        info.style.display = 'none';

        line.style.height = "2px";
        line.style.backgroundColor = "#2B2D33";

        line.classList.remove("line-enter-init");
        void line.offsetWidth;
        line.classList.add("line-enter-init");
    });

    inpt.addEventListener("blur", function (e) {
        cancel.style.display = 'block';

        inpt.placeholder = "Введите код";
        info.style.display = 'none';

        line.style.height = "1px";
        line.style.backgroundColor = "#aaabad";
    });
}

function submitSms () {
    document.getElementById( 'sendSms' ).value = 'true';
    document.forms[ 0 ].submit();
}

function tickToResentSMS ( seconds ) {

    var relink = document.getElementsByClassName( 'resend_link' )[0];
    var retext = document.getElementsByClassName( 'text_resent' )[0];
    var ptext = document.getElementsByClassName( 'text' )[0];

    if(seconds === 0)
    {
        relink.style.opacity = "1";
        retext.style.opacity = "0";
        ptext.style.opacity  = "0";
        relink.addEventListener("click", function (e) {
            tickToResentSMS();
        });

        return;
    }

    var sec = seconds || 15;
    var text = "Повторно код можно будет отправить<br>через " + sec + " сек.";

    relink.style.opacity = "0";
    ptext.style.opacity  = "1";
    retext.style.opacity = "1";
    retext.innerHTML = text;

    setTimeout(function () {
        sec--;
        tickToResentSMS(sec);
    }, 1000)
}