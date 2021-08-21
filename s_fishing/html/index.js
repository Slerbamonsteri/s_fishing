$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }
    function sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    let progress = 0;
    let divide = 0;
    let doTimer = false;


    
    async function countdown() {
        //document.getElementById('timer').style.width = '480px';
        let timerWidth = '500';
        for (i = 0; i < 500; i++) {
            if (doTimer) {
                timerWidth = timerWidth - 1
                document.getElementById('timer').style.width = timerWidth + 'px';
                await sleep(8)
                if (timerWidth === 0) {
                    playingGame = false;
                    timerStarted = false;
                    $.post("https://s_fishing/error", JSON.stringify({
                        error: "You took too long!"
                    }))
                    document.getElementById('1').style.backgroundColor = '';
                }
            } else {
                break;
            }
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
                progress = 0;
                divide = Math.floor(Math.random()*5)*5 + 5
                if (divide < 10) {
                    divide = 10
                }
                document.getElementById('timer').style.width = '500px';
                doTimer = true;
                countdown()
            } else {
                display(false)
            }
        }
    })


    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 27) {
            doTimer = false;
            $.post('https://s_fishing/exit', JSON.stringify({}));
            return
        } else if (data.which == 69) {
            progress = progress + divide;
            $("button").css("-webkit-box-shadow", "inset 4px 4px 0 #000000, 2px 4px 0 #000000");
            setTimeout(function(){
                $("button").css("-webkit-box-shadow", "");
            }, 30);
            if (progress > 255) {
                doTimer = false;
                $("button").css("background-color", "");
                $.post("https://s_fishing/error", JSON.stringify({
                        error: "Complete!"
                }))
            } else {
                $("button").css("background-color", "rgb(" + progress + "," + progress+ "," + progress + ")");
            }
        }
    };

})