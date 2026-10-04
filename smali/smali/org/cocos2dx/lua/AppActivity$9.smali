.class Lorg/cocos2dx/lua/AppActivity$9;
.super Ljava/lang/Object;
.source "AppActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lua/AppActivity;->checkIsUCPaySuccess(I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field private final synthetic val$luaCallbackFunction:I


# direct methods
.method constructor <init>(I)V
    .locals 0

    .prologue
    .line 1
    iput p1, p0, Lorg/cocos2dx/lua/AppActivity$9;->val$luaCallbackFunction:I

    .line 438
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .prologue
    .line 441
    sget v0, Lorg/cocos2dx/lua/AppActivity;->mIsPaymentOK:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 442
    iget v0, p0, Lorg/cocos2dx/lua/AppActivity$9;->val$luaCallbackFunction:I

    const-string v1, "OK"

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxLuaJavaBridge;->callLuaFunctionWithString(ILjava/lang/String;)I

    .line 443
    iget v0, p0, Lorg/cocos2dx/lua/AppActivity$9;->val$luaCallbackFunction:I

    invoke-static {v0}, Lorg/cocos2dx/lib/Cocos2dxLuaJavaBridge;->releaseLuaFunction(I)I

    .line 448
    :goto_0
    return-void

    .line 445
    :cond_0
    iget v0, p0, Lorg/cocos2dx/lua/AppActivity$9;->val$luaCallbackFunction:I

    const-string v1, "notOK"

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxLuaJavaBridge;->callLuaFunctionWithString(ILjava/lang/String;)I

    .line 446
    iget v0, p0, Lorg/cocos2dx/lua/AppActivity$9;->val$luaCallbackFunction:I

    invoke-static {v0}, Lorg/cocos2dx/lib/Cocos2dxLuaJavaBridge;->releaseLuaFunction(I)I

    goto :goto_0
.end method
