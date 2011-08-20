if (!kakule) {
  var kakule = {};
}

kakule.current = {
    lat: 0,
    lng: 0,
    location: undefined,
    geocode_data: undefined,
    date: new Date().setHours(0,0,0,0).toString()
};
