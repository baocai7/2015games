.class Lorg/cocos2dx/lua/AppActivity$12;
.super Ljava/lang/Object;
.source "AppActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lua/AppActivity;->exitUC()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .prologue
    .line 646
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 1
    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .prologue
    .line 648
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v0

    invoke-static {}, Lorg/cocos2dx/lua/AppActivity;->access$7()Lorg/cocos2dx/lua/AppActivity;

    move-result-object v1

    new-instance v2, Lorg/cocos2dx/lua/AppActivity$12$1;

    invoke-direct {v2, p0}, Lorg/cocos2dx/lua/AppActivity$12$1;-><init>(Lorg/cocos2dx/lua/AppActivity$12;)V

    invoke-virtual {v0, v1, v2}, Lcn/uc/gamesdk/UCGameSDK;->exitSDK(Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)V

    .line 661
    return-void
.end method
