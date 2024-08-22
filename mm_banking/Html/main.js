$(function() {
    function Show(bool) {
        if (bool) {
            $("#Root").fadeIn();
        } else {
            $("#Root").fadeOut();
            ResetTextFields();
        }
    }

    function UpdateStats(PlayerName, Currency) {
        $("#welcome").text("Tervetuloa " + PlayerName);
        $("#currency").text("Tilin saldo: " + Currency.toString() + "€");
    }

    function RequestStats() {
        fetch("https://mm_banking/requestStats", {
            method: "POST",
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            }
        })
    }

    function ResetTextFields() {
        $("#withdrawvalue").val("");
        $("#depositvalue").val("");
        $("#targetid").val("");
        $("#cashvalue").val("");
    }
    
    Show(false);

    $("#withdrawbutton").click(function() {
        var Value = $("#withdrawvalue").val();

        fetch("https://mm_banking/withdrawClient", {
            method: "POST",
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                Value: Value
            })
        })

        RequestStats();
    });

    $("#depositbutton").click(function() {
        var Value = $("#depositvalue").val();

        fetch("https://mm_banking/depositClient", {
            method: "POST",
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                Value: Value
            })
        })

        RequestStats();
    });

    $("#sendmoney").click(function() {
        var Id = $("#targetid").val();
        var Value = $("#cashvalue").val();
        
        fetch("https://mm_banking/accountTransferClient", {
            method: "POST",
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                TargetID: Id,
                Value: Value
            })
        })

        RequestStats();
    });

    $("#logoutbutton").click(function() {
        fetch("https://mm_banking/logout", {
            method: "POST",
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            }
        })
    });

    window.addEventListener("message", function(e) {
        let data = e.data;

        if (data.action === "openbank") {
            Show(true);
        }

        if (data.action === "closebank") {
            Show(false);
        }

        if (data.action === "updatestats") {
            UpdateStats(data.name, data.currency);
        }
    });
});