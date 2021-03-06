(function() {
  // Define filter operations
  window.shared || (window.shared = {});
  var Env = window.shared.Env;

  window.shared.MixpanelUtils = {
    registerUser: function(currentEducator) {
      if (!window.mixpanel) return;
      if (Env.railsEnvironment !== 'production') return;
      window.mixpanel.register({
        'isDemoSite': Env.isDemoSite,
        'educator_id': currentEducator.id,
        'educator_is_admin': currentEducator.admin,
        'educator_school_id': currentEducator.school_id
      });
    },
    track: function(key, attrs) {
      if (!window.mixpanel) return;
      return window.mixpanel.track(key, attrs);
    }
  };
})();