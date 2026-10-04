.class Lorg/cocos2dx/lua/AppActivity$3;
.super Ljava/lang/Object;
.source "AppActivity.java"

# interfaces
.implements Lcn/uc/gamesdk/UCCallbackListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lua/AppActivity;->ucSdkInit()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lcn/uc/gamesdk/UCCallbackListener",
        "<",
        "Ljava/lang/String;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lorg/cocos2dx/lua/AppActivity;


# direct methods
.method constructor <init>(Lorg/cocos2dx/lua/AppActivity;)V
    .locals 0

    .prologue
    .line 1
    iput-object p1, p0, Lorg/cocos2dx/lua/AppActivity$3;->this$0:Lorg/cocos2dx/lua/AppActivity;

    .line 161
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic callback(ILjava/lang/Object;)V
    .locals 0

    .prologue
    .line 1
    check-cast p2, Ljava/lang/String;

    invoke-virtual {p0, p1, p2}, Lorg/cocos2dx/lua/AppActivity$3;->callback(ILjava/lang/String;)V

    return-void
.end method

.method public callback(ILjava/lang/String;)V
    .locals 3
    .param p1, "statuscode"    # I
    .param p2, "msg"    # Ljava/lang/String;

    .prologue
    .line 165
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u6e38\u620f\u63a5\u6536\u5230\u7528\u6237\u9000\u51fa\u901a\u77e5\u3002"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 166
    .local v0, "s":Ljava/lang/String;
    const-string v1, "UCGameSDK"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 168
    const/16 v1, -0xa

    if-ne p1, v1, :cond_0

    .line 170
    iget-object v1, p0, Lorg/cocos2dx/lua/AppActivity$3;->this$0:Lorg/cocos2dx/lua/AppActivity;

    invoke-static {v1}, Lorg/cocos2dx/lua/AppActivity;->access$0(Lorg/cocos2dx/lua/AppActivity;)V

    .line 173
    :cond_0
    const/16 v1, -0xb

    if-ne p1, v1, :cond_1

    .line 175
    iget-object v1, p0, Lorg/cocos2dx/lua/AppActivity$3;->this$0:Lorg/cocos2dx/lua/AppActivity;

    invoke-static {v1}, Lorg/cocos2dx/lua/AppActivity;->access$1(Lorg/cocos2dx/lua/AppActivity;)V

    .line 178
    :cond_1
    if-nez p1, :cond_2

    .line 180
    iget-object v1, p0, Lorg/cocos2dx/lua/AppActivity$3;->this$0:Lorg/cocos2dx/lua/AppActivity;

    invoke-static {v1}, Lorg/cocos2dx/lua/AppActivity;->access$2(Lorg/cocos2dx/lua/AppActivity;)V

    .line 182
    iget-object v1, p0, Lorg/cocos2dx/lua/AppActivity$3;->this$0:Lorg/cocos2dx/lua/AppActivity;

    invoke-static {v1}, Lorg/cocos2dx/lua/AppActivity;->access$1(Lorg/cocos2dx/lua/AppActivity;)V

    .line 185
    :cond_2
    const/4 v1, -0x2

    if-ne p1, v1, :cond_3

    .line 187
    iget-object v1, p0, Lorg/cocos2dx/lua/AppActivity$3;->this$0:Lorg/cocos2dx/lua/AppActivity;

    invoke-static {v1}, Lorg/cocos2dx/lua/AppActivity;->access$3(Lorg/cocos2dx/lua/AppActivity;)V

    .line 189
    :cond_3
    return-void
.end method
