import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  store: service('store'),

  didReceiveAttrs() {
    this._super(...arguments);

    this.setProperties({
      title: this.get('book.title'),
      isbn: this.get('book.isbn'),
      publishDate: this.get('book.publishDate'),
      author: this.get('book.author')
    });
  },

  actions: {
    searchAuthor(query) {
      return this.get('store').query('author', { filter: { query } });
    },

    submitChanges(evt) {
      evt.preventDefault();

      this.onsubmit({
        title: this.get('title'),
        isbn: this.get('isbn'),
        publishDate: this.get('publishDate'),
        author: this.get('author')
      });
    }
  }
});
