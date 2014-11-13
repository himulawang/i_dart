part of lib_test_server_route;

/* example
Map serverRoute = {
    "V101": { // receive blob
        "handler": TestRouteLogic.echo,
        "params": {
            "n": "rs",
        },
        "locks": [],
        "encryptType": null,
        "reqEncrypt": false,
        "resEncrypt": false,
    },
};
*/

Map serverRoute = {
    "V101": { // receive blob
        "handler": TestRouteLogic.echo,
        "params": {
            "n": "rs",
        },
        "locks": [],
        "encryptType": null,
        "reqEncrypt": false,
        "resEncrypt": false,
    },
};
