.class Lorg/cocos2dx/lua/AppActivity$11;
.super Ljava/lang/Object;
.source "AppActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lua/AppActivity;->checkAndGetUCId(I)V
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
    iput p1, p0, Lorg/cocos2dx/lua/AppActivity$11;->val$luaCallbackFunction:I

    .line 624
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .prologue
    .line 628
    :cond_0
    sget-object v0, Lorg/cocos2dx/lua/AppActivity;->UserId:Ljava/lang/String;

    const-string v1, ""

    if-eq v0, v1, :cond_0

    .line 629
    iget v0, p0, Lorg/cocos2dx/lua/AppActivity$11;->val$luaCallbackFunction:I

    sget-object v1, Lorg/cocos2dx/lua/AppActivity;->UserId:Ljava/lang/String;

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxLuaJavaBridge;->callLuaFunctionWithString(ILjava/lang/String;)I

    .line 630
    iget v0, p0, Lorg/cocos2dx/lua/AppActivity$11;->val$luaCallbackFunction:I

    invoke-static {v0}, Lorg/cocos2dx/lib/Cocos2dxLuaJavaBridge;->releaseLuaFunction(I)I

    .line 635
    return-void
.end method
