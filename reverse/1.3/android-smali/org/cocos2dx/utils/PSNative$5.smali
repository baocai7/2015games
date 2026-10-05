.class final Lorg/cocos2dx/utils/PSNative$5;
.super Ljava/lang/Object;
.source "PSNative.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/utils/PSNative;->showAlertLua(I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$luaFunctionId:I


# direct methods
.method constructor <init>(I)V
    .locals 0

    .prologue
    .line 144
    iput p1, p0, Lorg/cocos2dx/utils/PSNative$5;->val$luaFunctionId:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .prologue
    .line 147
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    iget v1, p0, Lorg/cocos2dx/utils/PSNative$5;->val$luaFunctionId:I

    invoke-virtual {v0, v1}, Lorg/cocos2dx/utils/PSDialog;->setLuaListener(I)Lorg/cocos2dx/utils/PSDialog;

    .line 148
    invoke-static {}, Lorg/cocos2dx/utils/PSNative;->showAlert()V

    .line 149
    return-void
.end method
