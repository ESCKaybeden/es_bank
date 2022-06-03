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


    window.addEventListener('message', function(event) {
        var item = event.data;

        if (item.type === "transfer") {
            $('.bank-transfer-history').append(`<div class="bank-transfer-info"><img src="./img/transfer.png" alt=""> ${event.data.target} <div class="iban">IBAN:${event.data.targetid})</div></div>`);
            $(".bank-no-user").hide();
        }

        if (item.type === "info") {

         $("#withdraw").val("")
         $("#deposit").val("")
         $("#transfer-id").val("")
         $("#transfer-amount").val("")

        var formatter = new Intl.NumberFormat('en-US', {style: 'currency',currency: 'USD',});

        let bank = event.data.cash

         $( ".bank-balance-avatar p").html("Hello, " + event.data.player);

         $( ".bank-balance-border p").html(formatter.format(event.data.cash));

         $('.bank-balance-avatar img').attr('src', event.data.avatar);

            if(bank > event.data.cardsilver ){
                $('.bank-balance-icon').attr('src', './img/gold.png');
                let card = "Gold"

                $(".bank-balance-avatar h1").css({"color": "yellow",});
                
            $( ".bank-balance-avatar h1").html(card);
            }else{
                $('.bank-balance-icon').attr('src', './img/silver.png');
                let card = "Silver"
                
            $( ".bank-balance-avatar h1").html(card);

            $(".bank-balance-avatar h1").css({"color": "white",});
            }
            
            if(bank > event.data.cardgold){
                $('.bank-balance-icon').attr('src', './img/diamond.png');
                let card = "Diamond"
                
            $( ".bank-balance-avatar h1").html(card);

            $(".bank-balance-avatar h1").css({"color": "aqua",});

            }

            BillingData();

        }
    })
    

    $(document).on("click",".billing-pay",function() {

        let price = $(this).attr('amount');

        let reason = $(".billing-info").html();

        let data = $(this).attr('data');

        $(".bank-billing-header-text h1").css({"display": "none"});

        $(".bank-no-billing-image").css({"display": "none"});

        $(".bank-yes-or-no button").css({"display": "block"});


        $(document).on("click",".bank-yes",function() {
            $.post('http://bank/Billing:SaveInvoice', JSON.stringify({
                price, reason, data
            }));
          $(".bank-yes-or-no button").css({"display": "none"});
        });

        $(document).on("click",".bank-no",function() {
            $(".bank-yes-or-no button").css({"display": "none"});
        });

      });

BillingData = function () {
    $.post('http://bank/Billing:Sorgu', JSON.stringify({}), function (cbData) {
        let bills = ""
        if (cbData.length > 0) {
            for (let index = 0; index < cbData.length; index++) {
                
                const data = cbData[index];

                var formatter = new Intl.NumberFormat('en-US', {style: 'currency',currency: 'USD',});
                
                bills = `

                <div class="bank-billing-history-info"><div class="billing-radius"><div class="billing-price">${formatter.format(data.amount)}$</div></div><div class="billing-info">${data.label}</div><div class="billing-pay" data="${data.id}" amount="${data.amount}"><button>PAY</button></div></div>
      
                 ` + bills

                }
                $(".bank-billing-history-get").html(bills)
                $(".bank-billing-header-text h1").css({"display": "none"});
                $(".bank-no-billing-image").css({"display": "none"});
                } else {
                $(".bank-billing-header-text h1").css({"display": "block"});
                $(".bank-billing-history-info").css({"display": "none"});
                $(".bank-no-billing-image").css({"display": "block"});
            }
    });
}

    document.onkeyup = function(data) {
        if (data.which == 27) {
            $.post('http://bank/exit', JSON.stringify({}));
            $("#withdraw").val("")
            $("#deposit").val("")
            $("#transfer-id").val("")
            $("#transfer-amount").val("")
        }
    };


    $(".bank-exit").click(function() {
        $.post('http://bank/exit', JSON.stringify({}));
        $("#withdraw").val("")
        $("#deposit").val("")
        $("#transfer-id").val("")
        $("#transfer-amount").val("")
        return
    })




$(document).on("click",".bank-withdraw-border-icon",function() {

        let withdraw = $("#cash-withdraw").val()

        var formatter = new Intl.NumberFormat('en-US', {style: 'currency',currency: 'USD',});

        if (withdraw <= 0 || isNaN(withdraw)) {
            return
        }

        $.post('http://bank/withdraw', JSON.stringify({
            value: withdraw
        }));

        $('.bank-transactions-history').append(`<div class="bank-transactions-info"><img src="./img/cash.png" alt=""> WİTHDRAW <div class="amount"> -${formatter.format(withdraw)}$</div></div>`);

        $(".bank-no-transfer").hide();

        $("#cash-withdraw").val("")
});


$(document).on("click",".bank-deposit-border-icon",function() {
        let deposit = $("#cash-deposit").val()

        var formatter = new Intl.NumberFormat('en-US', {style: 'currency',currency: 'USD',});

        if (deposit <= 0 || isNaN(deposit)) {
            return
        }

        $.post('http://bank/deposit', JSON.stringify({
            deposit: deposit
        }));

        $('.bank-transactions-history').append(`<div class="bank-transactions-info"><img src="./img/cash.png" alt=""> DEPOSIT <div class="amount-deposit"> -${formatter.format(deposit)}$</div></div>`);

        $(".bank-no-transfer").hide();

        $("#cash-deposit").val("")
});


$(document).on("click",".bank-transfer-icon",function() {

    let id = $("#cash-transfer").val()

    let amount = $("#amount").val()

    var formatter = new Intl.NumberFormat('en-US', {style: 'currency',currency: 'USD',});

    
    if (amount <= 0 || isNaN(amount) || id <= 0 || isNaN(id)) {
        return
    }

    $.post('http://bank/transfer', JSON.stringify({
        amount: amount,
        player: id
    }));

    $('.bank-transactions-history').append(`<div class="bank-transactions-info"><img src="./img/cash.png" alt=""> TRANSFER <div class="amount"> -${formatter.format(amount)}$</div></div>`);


    $(".bank-no-user").hide();

    $(".bank-no-transfer").hide();

    $("#cash-transfer").val("")

    $("#amount").val("")
});


    let click = false;
    $(document).on("click",".download",function() {
        click = !click
        if (click == true){
            $(".bank-billing-history-get").show(); 
        }else if (click == false){
            $(".bank-billing-history-get").hide(); 
        }
     $( ".bank-billing-history-arkaplan" ).toggle( "speed", function() {
        BillingData();
        $(".bank-info").toggle("speed"); 
        $(".bank-billing-history-header").toggle("speed"); 
        $(".bank-billing-header-text").toggle("speed"); 
        $(".bank-billing-header-icon").toggle("speed"); 
     });
  });
  

     $(document).ready(function(){ 
        $(".bank-billing-history-header").hide();
        $(".bank-billing-header-text").hide();
        $(".bank-billing-header-icon").hide();
        $(".bank-billing-history-arkaplan").hide();
        $(".bank-billing-history-get").hide(); 
        $(".bank-exit h1").hide();
		$(".bank-exit").hover(function(){ 
           $(".bank-exit h1").show();
		}, function(){ 
           $(".bank-exit h1").hide();
		});
	  });


});
