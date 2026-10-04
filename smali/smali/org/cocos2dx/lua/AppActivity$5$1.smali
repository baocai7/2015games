.class Lorg/cocos2dx/lua/AppActivity$5$1;
.super Ljava/lang/Object;
.source "AppActivity.java"

# interfaces
.implements Lcn/uc/gamesdk/UCCallbackListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lua/AppActivity$5;->run()V
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
.field final synthetic this$1:Lorg/cocos2dx/lua/AppActivity$5;


# direct methods
.method constructor <init>(Lorg/cocos2dx/lua/AppActivity$5;)V
    .locals 0

    .prologue
    .line 1
    iput-object p1, p0, Lorg/cocos2dx/lua/AppActivity$5$1;->this$1:Lorg/cocos2dx/lua/AppActivity$5;

    .line 265
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic callback(ILjava/lang/Object;)V
    .locals 0

    .prologue
    .line 1
    check-cast p2, Ljava/lang/String;

    invoke-virtual {p0, p1, p2}, Lorg/cocos2dx/lua/AppActivity$5$1;->callback(ILjava/lang/String;)V

    return-void
.end method

.method public callback(ILjava/lang/String;)V
    .locals 3
    .param p1, "code"    # I
    .param p2, "msg"    # Ljava/lang/String;

    .prologue
    .line 268
    const-string v0, "UCGameSDK"

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "UCGameSdk\u767b\u5f55\u63a5\u53e3\u8fd4\u56de\u6570\u636e:code="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 269
    const-string v2, ",msg="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 268
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 273
    if-nez p1, :cond_0

    .line 276
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v0

    invoke-virtual {v0}, Lcn/uc/gamesdk/UCGameSDK;->getSid()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lorg/cocos2dx/lua/AppActivity;->UserId:Ljava/lang/String;

    .line 277
    const-string v0, "sid HOOOOOOOOOOOO"

    sget-object v1, Lorg/cocos2dx/lua/AppActivity;->UserId:Ljava/lang/String;

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 281
    iget-object v0, p0, Lorg/cocos2dx/lua/AppActivity$5$1;->this$1:Lorg/cocos2dx/lua/AppActivity$5;

    invoke-static {v0}, Lorg/cocos2dx/lua/AppActivity$5;->access$0(Lorg/cocos2dx/lua/AppActivity$5;)Lorg/cocos2dx/lua/AppActivity;

    move-result-object v0

    invoke-static {v0}, Lorg/cocos2dx/lua/AppActivity;->access$4(Lorg/cocos2dx/lua/AppActivity;)V

    .line 283
    iget-object v0, p0, Lorg/cocos2dx/lua/AppActivity$5$1;->this$1:Lorg/cocos2dx/lua/AppActivity$5;

    invoke-static {v0}, Lorg/cocos2dx/lua/AppActivity$5;->access$0(Lorg/cocos2dx/lua/AppActivity$5;)Lorg/cocos2dx/lua/AppActivity;

    move-result-object v0

    invoke-static {v0}, Lorg/cocos2dx/lua/AppActivity;->access$5(Lorg/cocos2dx/lua/AppActivity;)V

    .line 287
    :cond_0
    const/16 v0, -0xa

    if-ne p1, v0, :cond_1

    .line 289
    iget-object v0, p0, Lorg/cocos2dx/lua/AppActivity$5$1;->this$1:Lorg/cocos2dx/lua/AppActivity$5;

    invoke-static {v0}, Lorg/cocos2dx/lua/AppActivity$5;->access$0(Lorg/cocos2dx/lua/AppActivity$5;)Lorg/cocos2dx/lua/AppActivity;

    move-result-object v0

    invoke-static {v0}, Lorg/cocos2dx/lua/AppActivity;->access$0(Lorg/cocos2dx/lua/AppActivity;)V

    .line 296
    :cond_1
    return-void
.end method
