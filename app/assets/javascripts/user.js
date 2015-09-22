var ready = function () {
  $(".start-conversation").click(function(e){
    e.preventDefault();

    var sender_id = $(this).data("sid");
    var receiver_id = $(this).data("rid");

    $.post("/conversations", {sender_id: sender_id, receiver_id: receiver_id}, function(data){
      chatWith(data.conversation_id);
    });
  });

  $(document).on("click", ".toggleChatBox", function(e){
    e.preventDefault();

    var id = $(this).data("cid");
    toggleChatBoxGrowth(id);
  });

  $(document).on("click", ".closeChatBox", function(e){
    e.preventDefault();

    var id = $(this).data("cid");
    closeChatBox(id);
  });

  $("a.conversation").click(function(e){
    e.preventDefault();

    var conversation_id = $(this).data("cid");
    chatWith(conversation_id);
  });

  $(document).on("keydown", ".chatboxtextarea", function(e){
    var id = $(this).data("cid");
    checkChatBoxInputKey(e, $(this), id);
  });
}

$(document).ready(ready);
$(document).on("page:load", ready);
