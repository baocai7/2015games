.class Lorg/cocos2dx/utils/PSDialog$1$1;
.super Ljava/lang/Object;
.source "PSDialog.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/utils/PSDialog$1;->onClick(Landroid/content/DialogInterface;I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lorg/cocos2dx/utils/PSDialog$1;

.field private final synthetic val$which:I


# direct methods
.method constructor <init>(Lorg/cocos2dx/utils/PSDialog$1;I)V
    .locals 0

    .prologue
    .line 1
    iput-object p1, p0, Lorg/cocos2dx/utils/PSDialog$1$1;->this$1:Lorg/cocos2dx/utils/PSDialog$1;

    iput p2, p0, Lorg/cocos2dx/utils/PSDialog$1$1;->val$which:I

    .line 40
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .prologue
    .line 43
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    .line 44
    .local v1, "map":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/String;>;"
    const-string v2, "buttonIndex"

    iget v3, p0, Lorg/cocos2dx/utils/PSDialog$1$1;->val$which:I

    neg-int v3, v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 45
    sget-object v2, Ljava/lang/System;->out:Ljava/io/PrintStream;

    iget v3, p0, Lorg/cocos2dx/utils/PSDialog$1$1;->val$which:I

    neg-int v3, v3

    invoke-virtual {v2, v3}, Ljava/io/PrintStream;->println(I)V

    .line 46
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0, v1}, Lorg/json/JSONObject;-><init>(Ljava/util/Map;)V

    .line 48
    .local v0, "jObject":Lorg/json/JSONObject;
    iget-object v2, p0, Lorg/cocos2dx/utils/PSDialog$1$1;->this$1:Lorg/cocos2dx/utils/PSDialog$1;

    invoke-static {v2}, Lorg/cocos2dx/utils/PSDialog$1;->access$0(Lorg/cocos2dx/utils/PSDialog$1;)Lorg/cocos2dx/utils/PSDialog;

    move-result-object v2

    invoke-static {v2}, Lorg/cocos2dx/utils/PSDialog;->access$0(Lorg/cocos2dx/utils/PSDialog;)I

    move-result v2

    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v3

    .line 47
    invoke-static {v2, v3}, Lorg/cocos2dx/lib/Cocos2dxLuaJavaBridge;->callLuaFunctionWithString(ILjava/lang/String;)I

    .line 50
    iget-object v2, p0, Lorg/cocos2dx/utils/PSDialog$1$1;->this$1:Lorg/cocos2dx/utils/PSDialog$1;

    invoke-static {v2}, Lorg/cocos2dx/utils/PSDialog$1;->access$0(Lorg/cocos2dx/utils/PSDialog$1;)Lorg/cocos2dx/utils/PSDialog;

    move-result-object v2

    invoke-static {v2}, Lorg/cocos2dx/utils/PSDialog;->access$0(Lorg/cocos2dx/utils/PSDialog;)I

    move-result v2

    invoke-static {v2}, Lorg/cocos2dx/lib/Cocos2dxLuaJavaBridge;->releaseLuaFunction(I)I

    .line 51
    return-void
.end method
