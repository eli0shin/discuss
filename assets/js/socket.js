import { Socket } from "phoenix";

let socket = new Socket("/socket", { params: { token: window.userToken } });

socket.connect();

const createSocket = topicId => {
  const channel = socket.channel(`comments:${topicId}`, {});
  channel
    .join()
    .receive("ok", res => {
      const { comments } = res;

      renderComments(comments);
    })
    .receive("error", res => {
      console.log("Unable to join", res);
    });

  channel.on(`comments:${topicId}:new`, renderComment);

  document.getElementById("comment-form").addEventListener("submit", event => {
    event.preventDefault();

    const commentBox = document.getElementById("comment-textarea");

    const comment = commentBox.value;

    if (comment.length < 1) return;

    channel.push("comment:add", { content: comment });

    commentBox.value = "";

    return false;
  });
};

function renderComments(comments) {
  if (!Array.isArray(comments) || comments.length < 1) return;

  const renderedComments = comments.map(comment => {
    return commentTemplate(comment);
  });

  document.querySelector(".collection").innerHTML = renderedComments.join(" ");
}

function renderComment({ comment }) {
  const renderedComment = commentTemplate(comment);

  document.querySelector(".collection").innerHTML += renderedComment;
}

function commentTemplate(comment) {
  return `
    <li class="collection-item">
      <div class="secondary-content">${comment.user.email}</div>
      <div>${comment.content}</div>
    </li>
  `;
}

window.createSocket = createSocket;
