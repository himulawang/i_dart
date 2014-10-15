part of lib_test_route;

Map clientRoute = {
    "V101": { // echo
        "handler": TestRouteLogic.echo,
    },
    "onUnknown": { // echo
        "handler": TestRouteLogic.onUnknown,
    },
};
