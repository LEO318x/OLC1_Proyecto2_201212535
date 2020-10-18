
var currentTab;
var composeCount = 2;
$(function () {

    // Cuando hacemos click en una pestaña realizamos la siguiente función
    $("#myTab").on("click", "a", function (e) {
        e.preventDefault();

        $(this).tab('show');
        $currentTab = $(this);
    });


    registerComposeButtonEvent();
    registerCloseEvent();
});

// Añadimos las pestañas
function registerComposeButtonEvent() {
    $('#composeButton').click(function (e) {
        e.preventDefault();

        var tabId = "compose" + composeCount; // Identificador para la pestaña y poderla manipular después.
        

        $('.nav-tabs').append('<li class="nav-item"><a class="nav-link" href="#'  + tabId + '" onclick="encontrarInstanciaCM('+composeCount+');"><button class="close closeTab" type="button" >×</button>Pestaña ' + composeCount + '</a></li>');
        $('.tab-content').append('<div class="tab-pane animate__animated animate__bounceInUp" id="' + tabId + '"><textarea id="editor'+composeCount+'"></textarea></div>');
        
        $(this).tab('show');
        showTab(tabId);
        registerCloseEvent();
        composeCount = composeCount + 1; // Incrementamos el identificador
    });

}

// Método que añade la funcionalidad para cerrar la pestaña.
function registerCloseEvent() {

    $(".closeTab").click(function () {

        // Como hay varios elementos con la opción de cerrar, entonces vamos a seleccionar la pestaña donde hagamos click
        var tabContentId = $(this).parent().attr("href");
        $(this).parent().parent().remove(); // Removemos la parte <li> de la pestaña
        $('#myTab a:last').tab('show'); // Seleccionamos la pestaña
        $(tabContentId).remove(); // Eliminamos el contenido de la pestaña

    });
}

// Mostramos la pestaña
function showTab(tabId) {
    $('#myTab a[href="#' + tabId + '"]').tab('show');
}

// Regresamos la pestaña
function getCurrentTab() {
    return currentTab;
}

// Retornamos el contenido de la pestaña actual
function getElement(selector) {
    var tabContentId = $currentTab.attr("href");
    return $("" + tabContentId).find("" + selector);

}

// Eliminar pestaña actual
function removeCurrentTab() {
    var tabContentId = $currentTab.attr("href");
    $currentTab.parent().remove(); // Removemos la parte <li> de la pestaña
    $('#myTab a:last').tab('show'); // Seleccionamos la pestaña
    $(tabContentId).remove(); // Eliminamos el contenido de la pestaña
}