import { inject } from '@ember/service';
import Component from '@ember/component';

export default Component.extend({

  store: inject('store'),

  init() {
    this._super(...arguments);

    this.set('author', {
      first: '',
      last: ''
    });
  },

  actions: {
    saveAuthor(evt) {
      evt.preventDefault();

      const author = this.get('store').createRecord('author', this.author);
      author.save().then(() => {
        this.set('showModal', false);
        this.onsave(author);
      });
    }
  }
});
