.class Lorg/cocos2dx/lua/AppActivity$12$1;
.super Ljava/lang/Object;
.source "AppActivity.java"

# interfaces
.implements Lcn/uc/gamesdk/UCCallbackListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lua/AppActivity$12;->run()V
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
.field final synthetic this$1:Lorg/cocos2dx/lua/AppActivity$12;


# direct methods
.method constructor <init>(Lorg/cocos2dx/lua/AppActivity$12;)V
    .locals 0

    .prologue
    .line 1
    iput-object p1, p0, Lorg/cocos2dx/lua/AppActivity$12$1;->this$1:Lorg/cocos2dx/lua/AppActivity$12;

    .line 648
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic callback(ILjava/lang/Object;)V
    .locals 0

    .prologue
    .line 1
    check-cast p2, Ljava/lang/String;

    invoke-virtual {p0, p1, p2}, Lorg/cocos2dx/lua/AppActivity$12$1;->callback(ILjava/lang/String;)V

    return-void
.end method

.method public callback(ILjava/lang/String;)V
    .locals 1
    .param p1, "code"    # I
    .param p2, "msg"    # Ljava/lang/String;

    .prologue
    .line 651
    const/16 v0, -0x2bf

    if-eq v0, p1, :cond_0

    .line 654
    const/16 v0, -0x2be

    if-ne v0, p1, :cond_0

    .line 657
    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    .line 659
    :cond_0
    return-void
.end method
