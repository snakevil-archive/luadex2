var $html = $('html');
$html.removeClass('no-js').addClass('js');
if ($html.hasClass('masonry')) {
    ((list, item) => {
        var $list = $(list),
            $imgs = $list.find(item + ' img'),
            counter = 0,
            masonry = () => {
                if ($imgs.length == ++counter)
                    $list.masonry({
                        itemSelector: item
                    });
            };
        $imgs.each(function () {
            this.complete
                ? masonry()
                : $(this).on('load', masonry);
        });
    })('.masonry .-list', '.-item');
}
$('.-tooltip').tooltip();
