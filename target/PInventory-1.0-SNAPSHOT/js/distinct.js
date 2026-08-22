document.addEventListener("DOMContentLoaded", function () {

    const distinctCards =
        document.querySelectorAll(".distinct-card");

    if (!distinctCards.length) {
        return;
    }


    distinctCards.forEach(function (card) {

        card.addEventListener("click", function () {

            /*
             * Remove active class from other cards
             */
            distinctCards.forEach(function (otherCard) {

                if (otherCard !== card) {
                    otherCard.classList.remove("touch-active");
                }

            });


            /*
             * Toggle current card
             */
            card.classList.toggle("touch-active");

        });

    });

});