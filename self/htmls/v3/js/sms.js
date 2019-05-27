document.addEventListener( "DOMContentLoaded", listenSMSInput );

var countOfResend   = +window.sessionStorage.getItem("resendSMS") || 1;
var countWrong      = +window.sessionStorage.getItem("wrongSMS")  || 1;
var secondsToResend = +window.sessionStorage.getItem("secondsToResend") || 15;

function listenSMSInput () {

    var sms = document.getElementById( 'password' );
    sms && sms.addEventListener( 'keyup', function ( e ) {
        var len = this.value.toString().length;
        if ( len >= 4 ) SMSFormSubmit();
    } );

    sms && sms.addEventListener( 'keydown', function ( e ) {
        if ( e.key === "Enter") SMSFormSubmit();
    });

    var inpt = document.getElementById( 'password' );
    var cancel = document.getElementsByClassName( 'cancel_pay' )[ 0 ];
    var info = document.getElementsByClassName( 'info' )[ 0 ];
    var line = document.getElementsByClassName( 'line' )[ 0 ];
    var resendtxt = document.getElementsByClassName( 'resend_success' )[ 0 ];
    var resendwarn = document.getElementsByClassName( 'resend_warning' )[ 0 ];
    var qcash = document.getElementsByClassName( 'qcash' )[ 0 ];

    if ( typeof sendSuccess !== "undefined" ) {
        // line.style.height = "2px";
    }

    try {
        console.log("textCodeError:" + textCodeError);
    } catch ( e ) {}

    try {
        console.log("errorSMSCode:" + errorSMSCode);
    } catch ( e ) {}


    if ( typeof errorSMSCode !== "undefined" )
    {
        line.style.backgroundColor = "#e61e33";
        if ( resendtxt ) resendtxt.style.display = 'block';

        var remainedResend = 3 - countWrong;
        if( remainedResend < 0 ) remainedResend = 0;

        var endText = remainedResend == 1 ? " попытка." : " попытки.";
        resendwarn.innerHTML = "Неправильный код. Осталось " + remainedResend + endText;
    }

    if ( typeof textResend !== "undefined" ) {
         countOfResend = +textResend.toString().match( /\d/ );
         window.sessionStorage.setItem("resendSMS", countOfResend);
    }

    if ( typeof isQCash !== "undefined" ) {
        qcash.classList.add( "show-qcash" );
        qcash.addEventListener( "click", function ( e ) {
            qcash.classList.add( "hide-qcash" );
        } );

        setTimeout( function () {
            qcash.classList.add( "hide-qcash" );
        }, 7000 )
    }

    if ( info ) info.style.display = 'none';
    inpt && inpt.addEventListener( "focus", function ( e ) {
        // cancel.style.display = 'none';

        var isMobile = window.innerWidth < 620;
        isMobile && (cancel.style.display = 'none');

        inpt.placeholder = "";
        if ( info ) info.style.display = 'none';
        if ( resendtxt ) resendtxt.style.display = 'none';

        // line.style.height = "2px";
        line.style.backgroundColor = "#2B2D33";
        line.classList.remove( "line-enter-init" );
        void line.offsetWidth;
        line.classList.add( "line-enter-init" );
    } );

    inpt && inpt.addEventListener( "blur", function ( e ) {
        cancel.style.display = 'block';

        inpt.placeholder = "Введите код";
        if ( info ) info.style.display = 'none';

        // line.style.height = "1px";
        line.style.backgroundColor = "#aaabad";
    } );

    sms && tickToResentSMS( secondsToResend );
}

function SMSFormSubmit (  ) {

    addCountInLocal();
    document.getElementById( 'sendSms' ).value = '';
    document.getElementById( 'form_sms' ).submit();
}

function addCountInLocal () {
    countWrong = +window.sessionStorage.getItem("wrongSMS");
    if( !countWrong )
    {
        window.sessionStorage.setItem('wrongSMS', 1);
    } else
    {
        countWrong++;
        window.sessionStorage.setItem('wrongSMS', countWrong);
    }
}

function submitSms () {
    document.getElementById( 'sendSms' ).value = 'true';
    document.forms[ 0 ].submit();
}

function tickToResentSMS ( seconds ) {

    window.sessionStorage.setItem("secondsToResend", seconds );

    var relink = document.getElementsByClassName( 'resend_link' )[ 0 ];
    var retext = document.getElementsByClassName( 'text_resent' )[ 0 ];
    var ptext  = document.getElementsByClassName( 'text' )[ 0 ];

    if( countOfResend > 3 ) {
        ptext.style.opacity = "1";
        relink.style.display = "none";
        retext.style.display  = "none";

        return;
    }

    if ( seconds === 0 ) {
        relink.style.opacity = "1";
        retext.style.opacity = "0";
        ptext.style.opacity  = "0";

        relink.addEventListener( "click", function ( e ) {
            window.sessionStorage.removeItem("secondsToResend");
            submitSms();

            // tickToResentSMS();
        } );

        return;
    }

    var sec  = seconds || 15;
    var text = "Повторно код можно будет отправить<br>через " + sec + " сек.";

    relink.style.opacity = "0";
    ptext.style.opacity  = "1";
    retext.style.opacity = "1";
    retext.innerHTML = text;

    setTimeout( function () {
        sec--;
        tickToResentSMS( sec );
    }, 1000 )
}