import Component from '@ember/component';

export default Component.extend({
  didReceiveAttrs() {
    this._super(...arguments);
    this.setProperties({
      email: this.get('user.email'),
      password: this.get('user.password'),
    });
  },

  actions: {
    login(evt) {
      evt.preventDefault();

      this.onsubmit({
        email: this.email,
        password: this.password
      });
    }
  }
});
