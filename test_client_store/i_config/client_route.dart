part of lib_test_client_store;

Map clientRoute = {
    "V101": { // echo
    "handler": TestRouteLogic.echo,
    },
    "onUnknown": { // echo
        "handler": TestRouteLogic.onUnknown,
    },
};
