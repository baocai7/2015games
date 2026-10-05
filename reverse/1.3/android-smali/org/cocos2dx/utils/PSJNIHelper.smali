.class public Lorg/cocos2dx/utils/PSJNIHelper;
.super Ljava/lang/Object;
.source "PSJNIHelper.java"


# static fields
.field static mArrayList:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static mHashMap:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static mVector:Ljava/util/Vector;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Vector",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    const/4 v0, 0x0

    .line 8
    sput-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mHashMap:Ljava/util/HashMap;

    .line 9
    sput-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mVector:Ljava/util/Vector;

    .line 10
    sput-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mArrayList:Ljava/util/ArrayList;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static createArrayList()V
    .locals 1

    .prologue
    .line 43
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sput-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mArrayList:Ljava/util/ArrayList;

    .line 44
    return-void
.end method

.method public static createHashMap()V
    .locals 1

    .prologue
    .line 13
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mHashMap:Ljava/util/HashMap;

    .line 14
    return-void
.end method

.method public static createVector()V
    .locals 1

    .prologue
    .line 28
    new-instance v0, Ljava/util/Vector;

    invoke-direct {v0}, Ljava/util/Vector;-><init>()V

    sput-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mVector:Ljava/util/Vector;

    .line 29
    return-void
.end method

.method public static getArrayList()Ljava/util/ArrayList;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .prologue
    .line 47
    sget-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mArrayList:Ljava/util/ArrayList;

    return-object v0
.end method

.method public static getHashMap()Ljava/util/HashMap;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .prologue
    .line 17
    sget-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mHashMap:Ljava/util/HashMap;

    return-object v0
.end method

.method public static getVector()Ljava/util/Vector;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Vector",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .prologue
    .line 32
    sget-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mVector:Ljava/util/Vector;

    return-object v0
.end method

.method public static pushArrayListElement(Ljava/lang/String;)V
    .locals 1
    .param p0, "value"    # Ljava/lang/String;

    .prologue
    .line 51
    sget-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mArrayList:Ljava/util/ArrayList;

    if-nez v0, :cond_0

    .line 55
    :goto_0
    return-void

    .line 54
    :cond_0
    sget-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mArrayList:Ljava/util/ArrayList;

    invoke-virtual {v0, p0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0
.end method

.method public static pushHashMapElement(Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "value"    # Ljava/lang/String;

    .prologue
    .line 21
    sget-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mHashMap:Ljava/util/HashMap;

    if-nez v0, :cond_0

    .line 25
    :goto_0
    return-void

    .line 24
    :cond_0
    sget-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mHashMap:Ljava/util/HashMap;

    invoke-virtual {v0, p0, p1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0
.end method

.method public static pushVectorElement(Ljava/lang/String;)V
    .locals 1
    .param p0, "value"    # Ljava/lang/String;

    .prologue
    .line 36
    sget-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mVector:Ljava/util/Vector;

    if-nez v0, :cond_0

    .line 40
    :goto_0
    return-void

    .line 39
    :cond_0
    sget-object v0, Lorg/cocos2dx/utils/PSJNIHelper;->mVector:Ljava/util/Vector;

    invoke-virtual {v0, p0}, Ljava/util/Vector;->add(Ljava/lang/Object;)Z

    goto :goto_0
.end method
