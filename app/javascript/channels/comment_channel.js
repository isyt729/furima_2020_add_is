import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const html = `<div class="comment">
                    <div class="comment_upper-info">
                      <div class="comment_upper-info_talker">
                        ${data.user_name}
                      </div>
                      <div class="comment_upper-info_date">
                        ${data.time}
                      </div>
                    </div>
                    <div class="comment_text">
                      <p class="lower-comment__content">
                        ${data.text}
                      </p>
                    </div>
                  </div>`
    const comment = document.getElementById('comments');
    const newComments = document.getElementById('comment-text');
    comment.insertAdjacentHTML('afterbegin', html);
    newComments.value='';
  }
});
