.class Lorg/cocos2dx/lua/AppActivity$5$2;
.super Ljava/lang/Object;
.source "AppActivity.java"

# interfaces
.implements Lcn/uc/gamesdk/IGameUserLogin;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lua/AppActivity$5;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lorg/cocos2dx/lua/AppActivity$5;


# direct methods
.method constructor <init>(Lorg/cocos2dx/lua/AppActivity$5;)V
    .locals 0

    .prologue
    .line 1
    iput-object p1, p0, Lorg/cocos2dx/lua/AppActivity$5$2;->this$1:Lorg/cocos2dx/lua/AppActivity$5;

    .line 302
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public process(Ljava/lang/String;Ljava/lang/String;)Lcn/uc/gamesdk/GameUserLoginResult;
    .locals 3
    .param p1, "userName"    # Ljava/lang/String;
    .param p2, "passWord"    # Ljava/lang/String;

    .prologue
    .line 308
    new-instance v0, Lcn/uc/gamesdk/GameUserLoginResult;

    invoke-direct {v0}, Lcn/uc/gamesdk/GameUserLoginResult;-><init>()V

    .line 311
    .local v0, "galr":Lcn/uc/gamesdk/GameUserLoginResult;
    iget-object v2, p0, Lorg/cocos2dx/lua/AppActivity$5$2;->this$1:Lorg/cocos2dx/lua/AppActivity$5;

    invoke-static {v2}, Lorg/cocos2dx/lua/AppActivity$5;->access$0(Lorg/cocos2dx/lua/AppActivity$5;)Lorg/cocos2dx/lua/AppActivity;

    move-result-object v2

    invoke-static {v2, p1, p2}, Lorg/cocos2dx/lua/AppActivity;->access$6(Lorg/cocos2dx/lua/AppActivity;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 312
    .local v1, "sid":Ljava/lang/String;
    if-eqz v1, :cond_0

    const-string v2, ""

    if-eq v1, v2, :cond_0

    .line 313
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_0

    .line 314
    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Lcn/uc/gamesdk/GameUserLoginResult;->setLoginResult(I)V

    .line 315
    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/GameUserLoginResult;->setSid(Ljava/lang/String;)V

    .line 321
    :goto_0
    return-object v0

    .line 318
    :cond_0
    const/16 v2, -0xc9

    invoke-virtual {v0, v2}, Lcn/uc/gamesdk/GameUserLoginResult;->setLoginResult(I)V

    .line 319
    const-string v2, ""

    invoke-virtual {v0, v2}, Lcn/uc/gamesdk/GameUserLoginResult;->setSid(Ljava/lang/String;)V

    goto :goto_0
.end method
