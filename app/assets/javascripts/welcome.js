$(document).ready(function () {
    $("#notifyForm").submit(function () {
        event.preventDefault();
        var formData = {
            'email': $('input[name=emailId]').val(),
        };
        $.ajax({
            type: "POST",
            url: "welcome/notify",
            data: formData,
            success: function (msg) {
                document.getElementById("notifyResultLabel").innerHTML = msg["result"];
            },
            error: function () {
                document.getElementById("notifyResultLabel").innerHTML = msg["error"];
            }


        });
    });
});
